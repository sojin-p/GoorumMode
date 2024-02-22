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
        view.separatorColor = Constants.Color.Text.basicPlaceholder
        view.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        view.backgroundColor = Constants.Color.Background.basic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.rowHeight = 50
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
