//
//  SettingViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 5/17/24.
//

import Foundation

final class SettingViewModel {
    
    var settings: Observable<[UserSettingSection<Setting>]> = Observable([])
    
    init() {
        configureSettings()
    }
    
    func filteredData(_ section: Int) -> [Setting] {
        return settings.value[section].items.filter { !$0.isHidden }
    }
    
    func getNumberOfRows(_ section: Int) -> Int {
        return filteredData(section).count
    }
    
    func updateSwitchValue(_ indexPath: IndexPath, isOn: Bool) {
        
        let originData = settings.value[indexPath.section].items
        
        guard let actualIndex = originData.firstIndex(
            where: { $0.title == filteredData(indexPath.section)[indexPath.row].title }
        ) else { return } //0
        
        settings.value[indexPath.section].items[indexPath.row].isSwitchOn = isOn
        
        settings.value[indexPath.section].items[actualIndex + 1].isSwitchOn = isOn
        
    }

    private func configureSettings() {
        settings = Observable([
            UserSettingSection(
                title: .basic,
                items: [
                    Setting(
                        title: Setting.SettingTitle.noti,
                        mainIcon: Constants.IconImage.noti,
                        detailText: nil
                    ),
                    Setting(
                        title: Setting.SettingTitle.notiTime,
                        mainIcon: nil,
                        detailText: "10:00"
                    ),
                    Setting(
                        title: Setting.SettingTitle.info,
                        mainIcon: Constants.IconImage.info,
                        detailText: nil
                    )
                ]
            ), //basic
            UserSettingSection(
                title: .other,
                items: [
                    Setting(
                        title: Setting.SettingTitle.inquiry,
                        mainIcon: nil,
                        detailText: nil
                    )
                ]
            ) //other
        ]) //Observable
    }
    
}
