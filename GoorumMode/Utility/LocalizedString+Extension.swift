//
//  LocalizedString+Extension.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/19.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
}
