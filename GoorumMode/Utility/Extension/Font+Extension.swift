//
//  Font+Extension.swift
//  GoorumMode
//
//  Created by 박소진 on 10/23/24.
//

import SwiftUI

extension Font {
    
    init(uiFont: UIFont) {
        self = Font.custom(uiFont.fontName, size: uiFont.pointSize)
    }
    
}
