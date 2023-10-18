//
//  Animation+Enum.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/19.
//

import UIKit

enum Animation {
    
    typealias Element = (duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, scale: CGAffineTransform, alpha: CGFloat)
    
    case touchDown
    case touchUp
    
    var element: Element {
        switch self {
        case .touchDown:
            return Element(duration: 0, delay: 0, options: .curveLinear, scale: .init(scaleX: 0.9, y: 0.9), alpha: 1)
        case .touchUp:
            return Element(duration: 0, delay: 0, options: .curveLinear, scale: .identity, alpha: 1)
        }
    }
}
