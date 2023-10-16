//
//  TabBarController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/12.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let moodVC = {
        let vc = MoodViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(title: "", image: Constants.IconImage.list, tag: 0)
        return nav
    }()

    private let chartVC = {
        let vc = ChartViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: Constants.IconImage.stats, tag: 1)
        return vc
    }()

    private let settingVC = {
        let vc = SettingViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(title: "", image: Constants.IconImage.setting, tag: 2)
        return nav
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Constants.Color.iconTint.basicBlack
        tabBar.unselectedItemTintColor = Constants.Color.iconTint.unselected
        setViewControllers([moodVC, chartVC, settingVC], animated: true)

    }
    
}

