//
//  AddViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddViewController: BaseViewController {
    
    let mainView = AddView()
    var time: Date?
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
        } else {
            mainView.removeBarButton.isHidden = true
        }
    }
    
    @objc func pickMoodImageClicked() {
        
        let vc = PickMoodViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.completionHandler = { [weak self] imageName in
            self?.mainView.pickMoodImageView.image = UIImage(named: imageName)
            self?.moodImageName = imageName
        }
        
        present(nav, animated: true)
    }
    
    @objc func extendButtonClicked() {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [.large()]
            }
        }
        mainView.detailTextView.isHidden = false
    }
    
    
    @objc func timePickerChanged(_ sender: UIDatePicker) {
        time = sender.date
    }
    
    func doneButtonClicked() {
        
        guard let image = mainView.pickMoodImageView.image, image != mainView.pickMoodPlaceholder else {
            showAlert(title: "기분을 선택하세요.", massage: nil)
            return
        }
        
        let unselectedTime = mainView.timePicker.date
        
        guard let onelineText = mainView.oneLineTextField.text else {
            //nil
            return }
        
        if mainView.detailTextView.isHidden {
            mainView.detailTextView.text = ""
        }
        
        guard let detailText = mainView.detailTextView.text else {
            //nil
            return
        }
        
        if transtion == .add {
            print("추가 화면")
            
            let data = Mood(mood: moodImageName ?? MoodEmojis.placeholder, date: time ?? unselectedTime, onelineText: onelineText, detailText: detailText, image: "")
            MoodRepository.shared.createItem(data)
            completionHandler?(data)
            
        } else if transtion == .modify {
            print("수정 화면")
            
            guard let moods else { return }
            
            let data = Mood(mood: moodImageName ?? moods.mood, date: time ?? moods.date, onelineText: onelineText, detailText: detailText, image: "")
            
            MoodRepository.shared.updateItem(id: moods._id, mood: moodImageName ?? moods.mood, date: time ?? moods.date, onelineText: onelineText, detailText: detailText, image: "")
            
            completionHandler?(data)
        }
        
        dismiss(animated: true)
    }
    
    func removeButtonClicked() {
        showAlertWithAction(title: "일기가 삭제됩니다.", message: nil, buttonName: "삭제") { [weak self] in
            
            self?.removeData?()
            
            guard let moods = self?.moods else { return }
            MoodRepository.shared.deleteItem(moods)
       
            self?.dismiss(animated: true)
        }
    }
    
}

// MARK: - detailTextViewDelegate
extension AddViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if transtion == .modify {
            mainView.doneBarButton.isHidden = false
        } else {
            mainView.removeBarButton.isHidden = true
            mainView.doneBarButton.isHidden = false
        }
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
            sheet.detents = [detentsID]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
        
    }
    
    func setBarButtonItem() {
        
        let closeBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), primaryAction: .init(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))
        
        mainView.doneBarButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), primaryAction: .init(handler: { [weak self] action in
            self?.doneButtonClicked()
        }))
        
        mainView.removeBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), primaryAction: .init(handler: { [weak self] action in
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
    
    enum TransitionType {
        case add, modify
    }
}
