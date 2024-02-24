//
//  Setting.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

import UIKit

struct Setting {
    
    let title: String
    let mainIcon: UIImage?
    
    enum Section: Int, CaseIterable {
        case basic
        case other
        
        var item: [Setting] {
            switch self {
            case .basic:
                return [
                    Setting(title: "알림", mainIcon: Constants.IconImage.noti),
                    Setting(title: "정보", mainIcon: Constants.IconImage.info)
                ]
            case .other:
                return [
                    Setting(title: "문의하기", mainIcon: nil)
                ]
            }
        }
    }
}
