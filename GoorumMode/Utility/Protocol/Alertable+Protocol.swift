//
//  Alertable+Protocol.swift
//  GoorumMode
//
//  Created by 박소진 on 11/2/24.
//

import UIKit

protocol Alertable {
    func showAlert(on viewController: UIViewController, title: String, message: String?)
    func showAlertWithAction(on viewController: UIViewController, title: String, message: String?, buttonName: String, buttonStyle: UIAlertAction.Style, completion: @escaping () -> Void)
}
