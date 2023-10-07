//
//  IconImage.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit

extension Constants {
    
    enum IconImage {
        static let list = UIImage(named: "iconList")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let calendar = UIImage(named: "iconCalendar")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let setting = UIImage(named: "iconSetting")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let stats = UIImage(named: "iconStats")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let search = UIImage(named: "iconSearch")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let check = UIImage(named: "iconCheck")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let trash = UIImage(named: "iconTrash")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
        static let xMark = UIImage(named: "iconXmark")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack!)
    }
    
}
