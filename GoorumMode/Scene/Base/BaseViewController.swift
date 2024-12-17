//
//  BaseViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit
import SnapKit
import Toast

class BaseViewController: UIViewController {
    
    var toastStyle = {
        var view = ToastStyle()
        view.backgroundColor = .darkGray
        ToastManager.shared.style = view
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = Constants.Color.Background.basic
    }
    
    func setConstraints() { }
    
    func setupSheet(_ detentsID: [UISheetPresentationController.Detent], isModal: Bool) {
        isModalInPresentation = isModal
        
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = detentsID
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 20
            }
        }
        
    }
    
    func setNavigationBackBarButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBarbuttonClicked))
        backButton.accessibilityLabel = "backBarButton".localized
        navigationItem.leftBarButtonItem =  backButton
    }
    
    @objc private func backBarbuttonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}
