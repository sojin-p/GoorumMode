//
//  SettingUIViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 9/5/24.
//

import Foundation

final class SettingUIViewModel: ObservableObject {
    
    @Published var settings: [UserSettingSection] = [
        UserSettingSection(
            title: .basic,
            items: [
                SettingUI(
                    title: .noti,
                    iconName: "iconNotification",
                    type: .toggle(isOn: true)
                ),
                SettingUI(
                    title: .info,
                    iconName: "iconInfo",
                    type: .none
                ),
                SettingUI(
                    title: .inquiry,
                    iconName: Constants.IconImage.inquiry,
                    type: .none
                )
            ]
        ), //basic
        UserSettingSection(
            title: .other,
            items: [
                SettingUI(
                    title: .version,
                    iconName: nil,
                    type: .detailText(value: Constants.getVersion())
                )
            ]
        ) //other
    ]
    
    @Published var isNotificationOn: Bool = false {
        didSet {
            handleToggleChange()
        }
    }
    
    func handleToggleChange() {
        if isNotificationOn {
            print("isOn")
            insertNotiTime()
        } else {
            print("isOFF")
            removeNotiTime()
        }
    }
    
    func removeNotiTime() {
        guard let basicSectionIndex = settings.firstIndex(where: { $0.title == .basic }),
              let itemIndex = settings[basicSectionIndex].items.firstIndex(where: { $0.title == .notiTime }) else {
            return
        }
        
        settings[basicSectionIndex].items.remove(at: itemIndex)
    }
    
    func insertNotiTime() {
        
        guard let basicSectionIndex = settings.firstIndex(where: { $0.title == .basic }) else { return }
        
        let notiTime = SettingUI(
            title: .notiTime,
            iconName: Constants.IconImage.notiClock,
            type: .detailText(value: "오후 10:00")
        )
        
        settings[basicSectionIndex].items.insert(notiTime, at: 1)
    }
}

