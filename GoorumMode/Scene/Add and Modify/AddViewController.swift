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
    
    var transtion: TransitionType = .add
    
    var moods: Mood?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMaximumTime()
        
        setupSheet(.custom(resolver: { context in
            200
        }))
        
        setBarButtonItem()
        
        mainView.extendButton.addTarget(self, action: #selector(extendButtonClicked), for: .touchUpInside)
        
        mainView.pickMoodImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickMoodImageClicked)))
        
        mainView.timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        
        mainView.oneLineTextField.delegate = self
        mainView.detailTextView.delegate = self
        
        if transtion == .modify {
            setModifyView()
            setTime(date: mainView.timePicker.date)
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
        let nav = UINavigationController(rootViewController: vc)
        
        vc.completionHandler = { [weak self] imageName in
            self?.mainView.pickMoodImageView.image = UIImage(named: imageName)
            self?.moodImageName = imageName
            if self?.transtion == .modify {
                self?.mainView.doneBarButton.isHidden = false
            }
        }
        
        present(nav, animated: true)
    }
    
    @objc func extendButtonClicked(_ sender: UIButton) {
        if !(sender.isSelected) {
            mainView.extendButton.setImage(UIImage(systemName: "minus"), for: .normal)
            setupSheet(.large())
            mainView.detailTextView.isHidden = false
        } else {
            mainView.extendButton.setImage(UIImage(systemName: "plus"), for: .normal)
            setupSheet(.custom(resolver: { context in
                200
            }))
            mainView.detailTextView.isHidden = true
        }
        sender.isSelected.toggle()
    }
    
    
    @objc func timePickerChanged(_ sender: UIDatePicker) {
        showDoneBarButton()
        setTime(date: sender.date)
    }
    
    func doneButtonClicked() {
        
        guard let image = mainView.pickMoodImageView.image, image != mainView.pickMoodPlaceholder else {
            showAlert(title: "기분을 선택하세요.", massage: nil)
            return
        }
        
        let unselectedTime = mainView.timePicker.date
        let onelineText = mainView.oneLineTextField.text?.trimmingCharacters(in: .whitespaces)
        var detailText = mainView.detailTextView.text.trimmingCharacters(in: .whitespaces)
        
        if detailText == mainView.detailTextViewPlaceholder {
            detailText = ""
        }
        
        if mainView.detailTextView.isHidden {
            detailText = ""
        }
        
        if transtion == .add {
            print("추가 화면")
            let data = Mood(mood: moodImageName ?? MoodEmojis.placeholder, date: selectedDate ?? unselectedTime, onelineText: onelineText, detailText: detailText, image: "")
            MoodRepository.shared.createItem(data)
            completionHandler?(data)
            
        } else if transtion == .modify {
            print("수정 화면")
            guard let moods else { return }
            let data = Mood(mood: moodImageName ?? moods.mood, date: selectedDate ?? moods.date, onelineText: onelineText, detailText: detailText, image: "")
            
            data._id = moods._id
            self.moods = data
            
            MoodRepository.shared.updateItem(data)

            completionHandler?(data)
        }
        
        dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        showAlertWithAction(title: "일기가 삭제됩니다.", message: nil, buttonName: "삭제") { [weak self] in
            
            guard let moods = self?.moods else { return }

            self?.removeData?()
            
            MoodRepository.shared.deleteItem(moods._id)
       
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

        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard let text = textField.text, text.count < 15 else {
            textField.resignFirstResponder()
            showAlert(title: "15자 이하로 입력해 주세요.", massage: nil)
            return false
        }
        return true
    }
}

// MARK: - UI
extension AddViewController {
    
    func setupSheet(_ detentsID: UISheetPresentationController.Detent) {
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [detentsID]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 20
            }
        }
        
    }
    
    func setBarButtonItem() {
        
        let closeBarButton = UIBarButtonItem(image: Constants.IconImage.xMark, primaryAction: .init(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))
        
        mainView.doneBarButton = UIBarButtonItem(image: Constants.IconImage.check, primaryAction: .init(handler: { [weak self] action in
            self?.doneButtonClicked()
        }))
        
        mainView.removeBarButton = UIBarButtonItem(image: Constants.IconImage.trash, primaryAction: .init(handler: { [weak self] action in
            self?.removeButtonClicked()
        }))
        
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
            setupSheet(.large())
            mainView.detailTextView.text = moods.detailText
            mainView.detailTextView.isHidden = false
            mainView.detailTextView.textColor = Constants.Color.Text.basicTitle
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
