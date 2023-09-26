//
//  MoodCollectionViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class MoodCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    override func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    override func setConstraints() {
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
