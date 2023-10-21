//
//  ExtendButton.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/21.
//

import UIKit

class ExtendButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(name: "chevron.down.circle")
        tintColor = Constants.Color.iconTint.basicBlack
        accessibilityLabel = "extendButton_AccessibilityLabel".localized
        accessibilityHint = "extendButton_AccessibilityHint".localized
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet { self.changeImageWhenSelected() }
    }
    
    private func changeImageWhenSelected() {
        if self.isSelected {
            setImage(name: "chevron.up.circle")
        } else {
            setImage(name: "chevron.down.circle")
        }
    }
    
    private func setImage(name: String) {
        if let originalImage = UIImage(systemName: name) {
            let scaledImage = originalImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .light))
            setImage(scaledImage, for: .normal)
        }
    }
}
