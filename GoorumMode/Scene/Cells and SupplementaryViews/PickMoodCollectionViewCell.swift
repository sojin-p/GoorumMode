//
//  PickMoodCollectionViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/29.
//

import UIKit

class PickMoodCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PickMoodCollectionViewCell"
    
    let moodImage = {
        let view = UIImageView()
        view.backgroundColor = .blue
        return view
    }()
    
    override func configure() {
        contentView.addSubview(moodImage)
    }
    
    override func setConstraints() {
        moodImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
