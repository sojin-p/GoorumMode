//
//  TabBarController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let moodVC = {
        let vc = MoodViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: nil, image: Constants.IconImage.list, tag: 0)
        return nav
    }()
    
    private let calendarVC = {
        let vc = CalendarViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: nil, image: Constants.IconImage.calendar, tag: 1)
        return nav
    }()
    
    private let settingVC = {
        let vc = SettingViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: nil, image: Constants.IconImage.setting, tag: 2)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Constants.Color.Background.basic
        setViewControllers([moodVC, calendarVC, settingVC], animated: true)

    }
    
}
