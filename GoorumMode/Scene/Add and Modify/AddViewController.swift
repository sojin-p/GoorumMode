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
        
        let data = Mood(mood: moodImageName ?? MoodEmojis.placeholder, date: time ?? unselectedTime, onelineText: onelineText, detailText: detailText, image: "")
        
        MoodRepository.shared.createItem(data)
        completionHandler?(data)
        
        dismiss(animated: true)
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
        let close = UIBarButtonItem(image: UIImage(systemName: "xmark"), primaryAction: .init(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))
        
        let done = UIBarButtonItem(image: UIImage(systemName: "checkmark"), primaryAction: .init(handler: { [weak self] action in
            self?.doneButtonClicked()
        }))
        
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = done
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
    }
    
    enum TransitionType {
        case add, modify
    }
}
