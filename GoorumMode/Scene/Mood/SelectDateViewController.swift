//
//  SelectDateViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/09.
//

import UIKit

final class SelectDateViewController: BaseViewController {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.basic
        view.layer.cornerRadius = 25
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    override func configure() {
        view.addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}
