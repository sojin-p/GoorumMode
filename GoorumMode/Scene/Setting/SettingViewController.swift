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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let section = sections[indexPath.section]
        let row = section.item[indexPath.row]
        
        cell.textLabel?.text = row.title
        cell.imageView?.image = row.mainIcon
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.tintColor = Constants.Color.iconTint.basicBlack
        cell.backgroundColor = Constants.Color.Background.basic
        cell.textLabel?.font = Constants.Font.bold(size: 15)
        cell.textLabel?.textColor = Constants.Color.Text.basicTitle
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let url = NSURL(string: "https://goorumode.notion.site/3c6efe5be9ac4707b29689852505caf0?pvs=4")
            let safariView: SFSafariViewController = SFSafariViewController(url: url! as URL)
            self.present(safariView, animated: true, completion: nil)
            
        } else if indexPath.row == 1 {
            let instaUrl = NSURL(string: "https://instagram.com/goorumode?igshid=OGQ5ZDc2ODk2ZA%3D%3D&utm_source=qr")
            let instaSafariView: SFSafariViewController = SFSafariViewController(url: instaUrl! as URL)
            self.present(instaSafariView, animated: true, completion: nil)
        }
        
    }
}
