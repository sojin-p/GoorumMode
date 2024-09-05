//
//  IconImage.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit

extension Constants {
    
    enum IconImage {
        static let list = UIImage(resource: .iconList)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let calendar = UIImage(resource: .iconCalendar)
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let setting = UIImage(resource: .iconSetting)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let stats = UIImage(resource: .iconStats)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let search = UIImage(resource: .iconSearch)
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let check = UIImage(resource: .iconCheck)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let trash = UIImage(resource: .iconTrash)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let xMark = UIImage(resource: .iconXmark)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let edit = UIImage(resource: .iconEdit)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let info = UIImage(resource: .iconInfo)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let noti = UIImage(resource: .iconNotification)
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(Constants.Color.iconTint.basicBlack)
        
        static let notiClock = "iconClock"
        
        static let inquiry = "iconInquiry"
        
    }
    
}
