//
//  CapsulePaddingButton.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/13.
//

import UIKit

final class CapsulePaddingButton: UIButton {
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        setTitle(title, for: .normal)
        
        setTitleColor(Constants.Color.Text.basicSubTitle, for: .normal)
        setTitleColor(Constants.Color.Text.basicSubTitle, for: [.normal, .highlighted])
        
        setTitleColor(Constants.Color.Text.basicTitle, for: .selected)
        setTitleColor(Constants.Color.Text.basicTitle, for: [.selected, .highlighted])
        
        titleLabel?.font = Constants.Font.bold(size: 14)
        DispatchQueue.main.async {
            self.layer.cornerRadius = frame.height / 2
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + 30, height: size.height)
        }
    }
    
}
