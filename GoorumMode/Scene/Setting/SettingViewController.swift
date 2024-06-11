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
    
    let viewModel = SettingViewModel()
    
    let testt = false
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settingVC_Title".localized
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setBind()
    }
    
    func setBind() {
        viewModel.settings.bind { [weak self] data in
            print("========>>> test bind")
            DispatchQueue.main.async {
                self?.mainView.tableView.reloadData()
            }
            
        }
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier) as? SettingTableViewCell else {  return UITableViewCell() }
        
        let filteredData = viewModel.filteredData(indexPath.section)
        
        let row = filteredData[indexPath.row]
        
        let originData = viewModel.settings.value[indexPath.section].items
        
        cell.configureCell(row)
        
        cell.notiSwitch.setOn(originData[0].isSwitchOn, animated: true)
        
        cell.switchValueChangedHandler = { [weak self] isOn in
            self?.viewModel.updateSwitchValue(indexPath, isOn: isOn)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        switch viewModel.settings.value[indexPath.section].title {
        case .basic:
            print("clicked")
            
//            switch indexPath.row {
//            case 0:
//                let vc = NotificationViewController()
//                navigationController?.pushViewController(vc, animated: true)
//            case 2:
//                let vc = InfoViewController()
//                navigationController?.pushViewController(vc, animated: true)
//                
//            default: print("default")
//            }
            
        case .other:
            let instaUrl = NSURL(string: "https://instagram.com/goorumode?igshid=OGQ5ZDc2ODk2ZA%3D%3D&utm_source=qr")
            let instaSafariView: SFSafariViewController = SFSafariViewController(url: instaUrl! as URL)
            self.present(instaSafariView, animated: true, completion: nil)
            
        case .none:
            print("none")
        }
        
    }
    
}
