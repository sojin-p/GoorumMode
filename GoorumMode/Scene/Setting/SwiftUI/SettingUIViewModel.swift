//
//  SettingUIViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 9/5/24.
//

import Foundation
import UIKit

final class SettingUIViewModel: ObservableObject {
    
    @Published var settings: [UserSettingSection] = [
        UserSettingSection(
            title: .basic,
            items: [
                Setting(
                    title: .noti,
                    iconName: "iconNotification",
                    type: .toggle(isOn: true)
                ),
                Setting(
                    title: .diaryExport,
                    iconName: Constants.IconImage.export,
                    type: .action(.diaryExport)
                ),
                Setting(
                    title: .info,
                    iconName: "iconInfo",
                    type: .action(.info)//.none(isMail: false)
                ),
                Setting(
                    title: .inquiry,
                    iconName: Constants.IconImage.inquiry,
                    type: .action(.email)
                )
            ]
        ), //basic
        UserSettingSection(
            title: .other,
            items: [
                Setting(
                    title: .version,
                    iconName: nil,
                    type: .detailText(value: Constants.getVersion(), showPopUp: false)
                )
            ]
        ) //other
    ]
    
    @Published var isNotificationOn: Bool = false {
        didSet {
            saveNotiStatusToUserDefaults()
            handleToggleChange()
        }
    }
    
    @Published var navigateToNextPage = false {
        didSet {
            print(navigateToNextPage)
        }
    }
    
    @Published var time = Date()
    
    @Published var showingPopup = false
    
    init() {
        //UserDefaults에서 시간 불러오기
        if let savedTime = loadNotificationFromUserDefaults() {
            time = savedTime
            print("유저디폴트에서 시간 불러옴", time)
        } else {
            //디폴트 값
            var components = DateComponents()
            components.hour = 22
            components.minute = 0
            time = Calendar.current.date(from: components) ?? Date()
            print("유저디폴트에 시간 저장된게 없음")
        }
        
        //토글 상태 불러오기
        isNotificationOn = loadNotiStatusFromUserDefaults()
        print("유저디폴트에 저장된 스위치", isNotificationOn)
    }
    
    private func handleToggleChange() {
        if isNotificationOn {
            //저장된 시간이 없을 때만 저장
            if isNotificationTimeEmpty() {
                scheduleNotification(at: time)
            }
            insertNotiTime()
            
        } else {
            //저장된 시간이 있을 때만 삭제
            if !isNotificationTimeEmpty() {
                cancelNotification()
                removeNotificationFromUserDefaults()
            }
            removeNotiTime()
        }
    }
    
    private func saveNotiStatusToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(isNotificationOn, forKey: "isNotificationOn")
    }
    
    private func loadNotiStatusFromUserDefaults() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isNotificationOn")
    }
    
    func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    func scheduleNotification(at time: Date) {
        
        let center = UNUserNotificationCenter.current()
        
        //알림 내용
        let content = UNMutableNotificationContent()
        content.title = "CloudMode".localized
        content.body = "setting_NotificationBody".localized
        content.sound = .default
        
        //알림 발송 시간
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0
        
        //알림 반복 트리거
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //request 만들기
        let identifier = "moodNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { [weak self] error in
            if let error = error {
                print("알림 추가 실패: \(error.localizedDescription)")
            } else {
                print("알림 추가됨: \(self?.formattedTime(for: time) ?? "")")

                //UserDefaults에 저장
                self?.saveNotificationToUserDefaults(time)
            }
        }
    }
    
    //UserDefaults에 시간 저장
    private func saveNotificationToUserDefaults(_ time: Date) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "notificationTime")
        print("UserDefaults에 저장완료")
    }
    
    //UserDefaults에서 시간 불러오기
    private func loadNotificationFromUserDefaults() -> Date? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "notificationTime") as? Date
    }
    
    //UserDefaults에서 시간 삭제
    private func removeNotificationFromUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "notificationTime")
        print("UserDefaults에서 시간 삭제")
    }
    
    private func isNotificationTimeEmpty() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "notificationTime") == nil
    }

    private func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("알림 꺼짐")
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
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
        
        let notiTime = Setting(
            title: .notiTime,
            iconName: Constants.IconImage.notiClock,
            type: .detailText(value: "", showPopUp: true)
        )
        
        settings[basicSectionIndex].items.insert(notiTime, at: 1)
    }
    
    func sendEmail() {
        let email = "luv2hong@gmail.com"
        let subject = "[구름모드] 문의합니다."
        
        if let url = URL(string: "mailto:\(email)?subject=\(subject)") {
            UIApplication.shared.open(url)
        }
    }
}

