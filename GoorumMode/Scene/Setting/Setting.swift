//
//  Setting.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

import UIKit

//MARK: - UserSettingSection
struct UserSettingSection<T> {
    let title: SectionTitle?
    var items: [T]
    
    enum SectionTitle: String {
        case basic
        case other
    }

}

//MARK: - Setting
struct Setting {
    let title: SettingTitle
    let mainIcon: UIImage?
    let detailText: String?
    
    var hasSwitch: Bool {
        return title == .noti
    }
    
    var isSwitchOn: Bool = false
    
    var isHidden: Bool {
        return title == .notiTime && !isSwitchOn
    }
    
    //SettingTitle+Enum
    enum SettingTitle: String {
        case noti = "알림"
        case notiTime = "알림 시간"
        case info = "정보"
        case inquiry = "setting_Inquiry"
        
        func localized() -> String {
            return self.rawValue.localized
        }
    }
}

