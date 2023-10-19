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
    
    func showAlert(title: String, massage: String?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "alert_OKButtonTitle".localized, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showAlertWithAction(title: String, message: String?, buttonName: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: buttonName, style: .destructive) { action in
            completion()
        }
        let cancel = UIAlertAction(title: "alert_CancelButtonTitle".localized, style: .cancel)
        
        alert.addAction(button)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    
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
}
