//
//  Constants.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/25.
//

import UIKit

enum Constants {

    enum Font: String {
        case regular = "NanumSquareNeo-bRg"
        case bold = "NanumSquareNeo-cBd"
        case extraBold = "NanumSquareNeo-dEb"
        
        func of(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            return Font.regular.of(size: size)
        }
        
        static func bold(size: CGFloat) -> UIFont {
            return Font.bold.of(size: size)
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            return Font.extraBold.of(size: size)
        }
    }
    
}
