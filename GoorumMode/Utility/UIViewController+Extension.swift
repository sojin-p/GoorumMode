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

extension UILabel {
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
}
