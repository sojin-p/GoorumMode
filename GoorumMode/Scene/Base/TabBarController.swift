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
        nav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), tag: 0)
        return nav
    }()
    
    private let calendarVC = {
        let vc = CalendarViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star.fill"), tag: 0)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarController viewDidLoad")
        
        view.backgroundColor = .cyan
        tabBar.tintColor = Constants.Color.Background.basic
        tabBar.tintColor = Constants.Color.iconTint.basicBlack

        setViewControllers([moodVC, calendarVC], animated: true)

    }
    
}
