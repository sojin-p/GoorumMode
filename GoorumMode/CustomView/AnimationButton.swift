//
//  AnimationButton.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/18.
//

import UIKit

class AnimationButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet { self.animateWhenHighlighted() }
    }
    
    private func animateWhenHighlighted() {
        let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
        
        UIView.animate(withDuration: animationElement.duration, delay: animationElement.delay, options: animationElement.options, animations: {
                self.transform = animationElement.scale
                self.alpha = animationElement.alpha
            }
        )
    }
}
