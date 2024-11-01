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
    case none(isMail: Bool)
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
        case info = "setting_Info"
        case inquiry = "setting_Inquiry"
        
        //section2
        case version = "setting_Version"
        
        var accessibilityHint: String {
            switch self {
            case .notiTime: "알림 시간을 설정하려면 두 번 탭 하세요."
            case .info: "정책 등의 정보를 확인하려면 두 번 탭 하세요."
            case .inquiry: "개발자에게 문의 메일을 보내려면 두 번 탭 하세요."
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
            case .privacyPolicy: "개인정보 정책을 확인하려면 두 번 탭 하세요."
            }
        }
        
        func localized() -> String {
            return self.rawValue.localized
        }
    }
}
