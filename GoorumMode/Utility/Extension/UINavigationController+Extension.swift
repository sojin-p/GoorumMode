//
//  UINavigationController+Extension.swift
//  GoorumMode
//
//  Created by 박소진 on 10/24/24.
//

import UIKit

extension UINavigationController : UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    //Navigation Stack에 쌓인 뷰가 1개를 초과해야 제스처 동작
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return viewControllers.count > 1
    }

}
