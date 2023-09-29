//
//  AddViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddViewController: BaseViewController {
    
    let mainView = AddView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSheet()
        setBarButtonItem()
        
        mainView.extendButton.addTarget(self, action: #selector(extendButtonClicked), for: .touchUpInside)
        mainView.pickMoodImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickMoodImageClicked)))
        
        sheetPresentationController?.delegate = self
        mainView.oneLineTextField.delegate = self
        mainView.detailTextView.delegate = self
    }
    
    @objc func pickMoodImageClicked() {
        print("클릭 됨")
    }
    
    @objc func extendButtonClicked() {
        sheetPresentationController?.animateChanges {
            sheetPresentationController?.selectedDetentIdentifier = .large
            mainView.detailTextView.isHidden = false
        }
    }
    
    func setBarButtonItem() {
        let close = UIBarButtonItem(image: UIImage(systemName: "xmark"), primaryAction: .init(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))
        
        let done = UIBarButtonItem(image: UIImage(systemName: "checkmark"), primaryAction: .init(handler: { action in
            print("doneButtonClicked")
        }))
        
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = done
        navigationController?.navigationBar.tintColor = Constants.Color.iconTint.basicBlack
    }
    
}

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

extension AddViewController: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard let sheetId = sheetPresentationController.selectedDetentIdentifier else { return }
        sheetPresentationController.animateChanges {
            if sheetId.rawValue == "small" {
                print("작다")
                mainView.detailTextView.isHidden = true
            } else {
                print("크다")
                mainView.detailTextView.isHidden = false
            }
        }
    }
    
    func setupSheet() {
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
            return 200
        }
        
        if let sheet = sheetPresentationController {
            sheet.detents = [smallDetent, .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        
    }
}
