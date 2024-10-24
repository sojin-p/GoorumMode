//
//  SettingView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/20.
//

import UIKit

final class SettingView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = Constants.Color.Background.basic
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        view.rowHeight = 45
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
}
