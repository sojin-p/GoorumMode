//
//  SettingViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/11.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Constants.Color.Background.basic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.rowHeight = 50
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func configure() {
        super.configure()
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)번"
        cell.backgroundColor = Constants.Color.Background.white
        return cell
    }
}
