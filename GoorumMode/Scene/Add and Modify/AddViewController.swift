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
        sheetPresentationController?.delegate = self
        mainView.oneLineTextField.delegate = self
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
    }
    
}

extension AddViewController: UITextFieldDelegate {
    
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
