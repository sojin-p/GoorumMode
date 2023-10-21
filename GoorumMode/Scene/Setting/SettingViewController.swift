//
//  SettingViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/11.
//

import UIKit
import SafariServices

final class SettingViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    let mainView = SettingView()
    let settingList = ["setting_PrivacyPolicy".localized, "setting_Inquiry".localized]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settingVC_Title".localized
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setNavigationBackBarButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = settingList[indexPath.row]
        cell.backgroundColor = Constants.Color.Background.basic
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = Constants.Font.bold(size: 15)
        cell.textLabel?.textColor = Constants.Color.Text.basicTitle
        cell.selectionStyle = .none
        return cell
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
