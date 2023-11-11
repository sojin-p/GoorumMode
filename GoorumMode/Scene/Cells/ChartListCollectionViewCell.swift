//
//  ChartListCollectionViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/11/11.
//

import UIKit

final class ChartListCollectionViewCell: BaseCollectionViewCell {
    
    let iconImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemYellow
        return view
    }()
    
    let label = {
        let view = UILabel()
        view.text = "100.0%"
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    
    override func configure() {
        [iconImageView, label].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
