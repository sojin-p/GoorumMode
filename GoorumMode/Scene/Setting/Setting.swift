//
//  Setting.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

import UIKit
import Foundation

//MARK: - UserSettingSection
struct UserSettingSection<T>: Identifiable {
    var id = UUID()
    
    let title: SectionTitle?
    var items: [T]
}

enum SectionTitle: String {
    case basic
    case other
}

//MARK: - SettingType
enum SettingType {
    case toggle(isOn: Bool)
    case detailText(value: String, showPopUp: Bool)
    case none(isMail: Bool)
}

//MARK: - SettingUI
struct SettingUI: Identifiable {
    let id = UUID()
    let title: SettingTitle
    let iconName: String?
    let type: SettingType
    
    enum SettingTitle: String {
        case noti = "setting_Noti"
        case notiTime = "setting_NotiTime"
        case info = "setting_Info"
        case inquiry = "setting_Inquiry"
        
        case version = "setting_Version"
        
        func localized() -> String {
            return self.rawValue.localized
        }
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

