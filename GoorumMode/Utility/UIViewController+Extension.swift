//
//  UIViewController+Extension.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

extension UITextField {
    
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
    
}
