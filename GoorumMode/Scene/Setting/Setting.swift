//
//  Setting.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

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
//    case none(isMail: Bool)
    case action(SettingAction)
}

//MARK: - SettingAction
enum SettingAction {
    case email
    case diaryExport
    case info
    case version
}

//MARK: - Setting
struct Setting: Identifiable {
    let id = UUID()
    let title: SettingTitle
    let iconName: String?
    let type: SettingType
    let items: [Setting]? = nil
    
    enum SettingTitle: String {
        //section1
        case noti = "setting_Noti"
        case notiTime = "setting_NotiTime"
        case diaryExport = "setting_DiaryExport"
        case info = "setting_Info"
        case inquiry = "setting_Inquiry"
        
        //section2
        case version = "setting_Version"
        
        var accessibilityHint: String {
            switch self {
            case .notiTime: "setting_NotiTime_AccessibilityHint".localized
            case .diaryExport:
                "setting_DiaryExport_AccessibilityHint".localized
            case .info: "setting_Info_AccessibilityHint".localized
            case .inquiry: "setting_Inquiry_AccessibilityHint".localized
            default: ""
            }
        }
        
        func localized() -> String {
            return self.rawValue.localized
        }
    }
    
    enum Info: String {
        case privacyPolicy = "setting_PrivacyPolicy"
        
        var accessibilityHint: String {
            switch self {
            case .privacyPolicy: "setting_PrivacyPolicy_AccessibilityHint".localized
            }
        }
        
        func localized() -> String {
            return self.rawValue.localized
        }
    }
}
