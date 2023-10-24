//
//  AddViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddViewController: BaseViewController {
    
    let mainView = AddView()
    var selectedDate: Date?
    var completionHandler: ((Mood) -> Void)?
    var removeData: (() -> Void)?
    var moodImageName: String?
    let moodRepository = MoodRepository()
    var transtion: TransitionType = .add
    
    var moods: Mood?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMaximumTime()
        
        setupSheet([.custom(resolver: { context in
            200
        })], isModal: true)
        
        setBarButtonItem()
        
        mainView.extendButton.addTarget(self, action: #selector(extendButtonClicked), for: .touchUpInside)
        
        mainView.pickMoodImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickMoodImageClicked)))
        
        mainView.timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        
        mainView.oneLineTextField.delegate = self
        mainView.detailTextView.delegate = self
        
        if transtion == .modify {
            setModifyView()
            setTime(date: mainView.timePicker.date)
            guard let text = mainView.oneLineTextField.text else { return }
            mainView.countLabel.text = "\(text.count)/15"
        } else {
            pickMoodImageClicked()
            setTime()
            mainView.removeBarButton.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func pickMoodImageClicked() {
        
        let vc = PickMoodViewController()
        
        vc.completionHandler = { [weak self] imageName in
            self?.mainView.pickMoodImageView.image = UIImage(named: imageName)
            self?.moodImageName = imageName
            if self?.transtion == .modify {
                self?.mainView.doneBarButton.isHidden = false
            }
        }
        
        present(vc, animated: true)
    }
    
    @objc func extendButtonClicked(_ sender: UIButton) {
        if !(sender.isSelected) {
            setupSheet([.large()], isModal: true)
            mainView.detailTextView.isHidden = false
        } else {
            setupSheet([.custom(resolver: { context in
                200
            })], isModal: true)
            mainView.detailTextView.isHidden = true
        }
        sender.isSelected.toggle()
        mainView.doneBarButton.isHidden = false
    }
    
    
    @objc func timePickerChanged(_ sender: UIDatePicker) {
        showDoneBarButton()
        setTime(date: sender.date)
    }
    
    func doneButtonClicked() {
        
        guard let image = mainView.pickMoodImageView.image, image != mainView.pickMoodPlaceholder else {
            showAlert(title: "alert_DoneButtonClicked_Title".localized, massage: nil)
            return
        }
        
        let unselectedTime = mainView.timePicker.date
        let onelineText = mainView.oneLineTextField.text?.trimmingCharacters(in: .whitespaces)
        var detailText = mainView.detailTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if detailText == mainView.detailTextViewPlaceholder {
            detailText = ""
        }
        
        if mainView.detailTextView.isHidden {
            detailText = ""
        }
        
        if transtion == .add {
            let data = Mood(mood: moodImageName ?? MoodEmojis.placeholder, date: selectedDate ?? unselectedTime, onelineText: onelineText, detailText: detailText, images: [])
            moodRepository.createItem(data)
            completionHandler?(data)
            
        } else if transtion == .modify {
            guard let moods else { return }
            let data = Mood(mood: moodImageName ?? moods.mood, date: selectedDate ?? moods.date, onelineText: onelineText, detailText: detailText, images: [])
            
            data._id = moods._id
            self.moods = data
            
            moodRepository.updateItem(data)

            completionHandler?(data)
        }
        
        dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        showAlertWithAction(title: "alert_RemoveButtonClicked_Title".localized, message: nil, buttonName: "alert_RemoveButtonTitle".localized) { [weak self] in
            
            guard let moods = self?.moods else { return }

            self?.removeData?()
            
            self?.moodRepository.deleteItem(moods._id)
       
            self?.dismiss(animated: true)
        }
    }
    
    func setTime(date: Date = Date()) {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        if let setTime = calendar.date(bySettingHour: hour, minute: minute, second: second, of: selectedDate ?? Date()) {
            selectedDate = setTime
        }
    }
    
    func setMaximumTime() {
        let selectedDate = Calendar.current.startOfDay(for: selectedDate ?? Date() )
        let currentDate = Calendar.current.startOfDay(for: Date())
        if selectedDate != currentDate {
            mainView.timePicker.maximumDate = nil
        }
    }
    
}

// MARK: - detailTextViewDelegate
extension AddViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showDoneBarButton()
        if textView.text == mainView.detailTextViewPlaceholder {
            textView.text = nil
            textView.textColor = Constants.Color.Text.basicTitle
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = mainView.detailTextViewPlaceholder
            textView.textColor = Constants.Color.Text.basicPlaceholder
        }
    }
}

// MARK: - oneLineTextFieldDelegate
extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        doneButtonClicked()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDoneBarButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldString = textField.text, let newRange = Range(range, in: oldString) else { return true }
        
        let inputString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newString = oldString.replacingCharacters(in: newRange, with: inputString)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard newString.count < 16 else {
            textField.resignFirstResponder()
            showAlert(title: "alert_OneLineTextField_isEmpty_Title".localized, massage: nil)
            return false
        }
        
        mainView.countLabel.text = "\(newString.count)/15"
        
        return true
    }
}

// MARK: - UI
extension AddViewController {
    
    func setBarButtonItem() {
        
        let closeBarButton = UIBarButtonItem(image: Constants.IconImage.xMark, primaryAction: .init(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))
        
        closeBarButton.accessibilityLabel = "closeBarButton_AccessibilityLabel".localized
        
        mainView.doneBarButton = UIBarButtonItem(image: Constants.IconImage.check, primaryAction: .init(handler: { [weak self] action in
            self?.doneButtonClicked()
        }))
        
        mainView.doneBarButton.accessibilityLabel = "doneBarButton_AccessibilityLabel".localized
        mainView.doneBarButton.accessibilityHint = "doneBarButton_AccessibilityHint".localized
        
        mainView.removeBarButton = UIBarButtonItem(image: Constants.IconImage.trash, primaryAction: .init(handler: { [weak self] action in
            self?.removeButtonClicked()
        }))
        
        mainView.removeBarButton.accessibilityLabel = "removeBarButton_AccessibilityLabel".localized
        mainView.removeBarButton.accessibilityHint = "removeBarButton_AccessibilityHint".localized
        
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItems = [mainView.doneBarButton, mainView.removeBarButton]
        navigationController?.navigationBar.tintColor = Constants.Color.iconTint.basicBlack
    }
    
    func setModifyView() {
        guard let moods else { return }
        mainView.pickMoodImageView.image = UIImage(named: moods.mood)
        mainView.oneLineTextField.text = moods.onelineText
        mainView.timePicker.date = moods.date
        
        if let detailText = moods.detailText, !(detailText.isEmpty) {
            setupSheet([.large()], isModal: true)
            mainView.detailTextView.text = moods.detailText
            mainView.detailTextView.isHidden = false
            mainView.detailTextView.textColor = Constants.Color.Text.basicTitle
            mainView.extendButton.isSelected = true
        } else {
            mainView.extendButton.isSelected = false
        }
        
        mainView.doneBarButton.isHidden = true
        mainView.removeBarButton.isHidden = false
    }
    
    func showDoneBarButton() {
        if transtion == .modify {
            mainView.doneBarButton.isHidden = false
        } else {
            mainView.removeBarButton.isHidden = true
            mainView.doneBarButton.isHidden = false
        }
    }
    
    enum TransitionType {
        case add, modify
    }
}
