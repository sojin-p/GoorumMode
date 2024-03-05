//
//  SettingViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/11.
//

import UIKit
import SafariServices

final class SettingViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    private let mainView = SettingView()
    private let settingList = ["setting_PrivacyPolicy".localized, "setting_Inquiry".localized]
    
    let sections = Setting.Section.allCases
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settingVC_Title".localized
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier) as? SettingTableViewCell else {  return UITableViewCell() }
        
        let section = sections[indexPath.section]
        let row = section.item[indexPath.row]
        
        cell.configureCell(row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch sections[indexPath.section] {
        case .basic:
            
            switch indexPath.row {
            case 0:
                let vc = NotificationViewController()
                navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                let vc = InfoViewController()
                navigationController?.pushViewController(vc, animated: true)
                
            default: print("default")
            }
            
        case .other:
            let instaUrl = NSURL(string: "https://instagram.com/goorumode?igshid=OGQ5ZDc2ODk2ZA%3D%3D&utm_source=qr")
            let instaSafariView: SFSafariViewController = SFSafariViewController(url: instaUrl! as URL)
            self.present(instaSafariView, animated: true, completion: nil)
        }
        
    }
}
