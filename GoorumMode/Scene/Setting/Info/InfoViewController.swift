//
//  InfoViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/25.
//

import UIKit
import SafariServices

final class InfoViewController: BaseViewController {
    
    private let mainView = SettingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("InfoViewController")
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func configure() {
        super.configure()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier) as? SettingTableViewCell else {  return UITableViewCell() }
        
        cell.configureInfoCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let url = NSURL(string: "https://goorumode.notion.site/3c6efe5be9ac4707b29689852505caf0?pvs=4")
            let safariView: SFSafariViewController = SFSafariViewController(url: url! as URL)
            self.present(safariView, animated: true, completion: nil)
            
        default: print("default")
        }
    }
}
