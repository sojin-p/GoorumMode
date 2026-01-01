//
//  AlertManager.swift
//  GoorumMode
//
//  Created by 박소진 on 11/2/24.
//

import UIKit

final class AlertManager: Alertable {

    static let shared = AlertManager()
    
    private init() { }
    
    func showAlert(on viewController: UIViewController, title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "alert_OKButtonTitle".localized, style: .default)
        alert.addAction(ok)
        viewController.present(alert, animated: true)
    }
    
    func showAlertWithAction(on viewController: UIViewController, title: String, message: String? = nil, buttonName: String, buttonStyle: UIAlertAction.Style, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: buttonName, style: buttonStyle) { action in
            completion()
        }
        let cancel = UIAlertAction(title: "alert_CancelButtonTitle".localized, style: .cancel)
        
        alert.addAction(button)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true)
    }
}
