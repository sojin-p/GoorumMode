//
//  TabBarController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/12.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    
    private let moodVC = {
        let vc = MoodViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(title: "record".localized, image: Constants.IconImage.list, tag: 0)
        return nav
    }()

    private let chartVC = {
        let vc = ChartViewController()
        vc.tabBarItem = UITabBarItem(title: "chart".localized, image: Constants.IconImage.stats, tag: 1)
        return vc
    }()

    private let settingVC = {
        let view = SettingUIView()
        let vc = UIHostingController(rootView: view)
        vc.tabBarItem = UITabBarItem(title: "setting".localized, image: Constants.IconImage.setting, tag: 2)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Constants.Color.iconTint.basicBlack
        tabBar.unselectedItemTintColor = Constants.Color.iconTint.unselected
        setViewControllers([moodVC, chartVC, settingVC], animated: true)

    }
    
}

