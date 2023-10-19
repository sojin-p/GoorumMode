//
//  PaddingLabel.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/19.
//

import UIKit

final class PaddingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var padding = UIEdgeInsets(top: 5, left: 12, bottom: 10, right: 12)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += padding.top + padding.bottom
        size.width += padding.left + padding.right
        return size
    }
}
