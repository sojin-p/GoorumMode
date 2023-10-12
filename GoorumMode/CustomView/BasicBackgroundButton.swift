//
//  BasicBackgroundButton.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/12.
//

import UIKit

final class BasicBackgroundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(Constants.Color.Text.basicSubTitle, for: .normal)
        backgroundColor = Constants.Color.Background.basic
        titleLabel?.font = Constants.Font.bold(size: 15)
        layer.cornerRadius = 14
        
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + 17, height: size.height)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
