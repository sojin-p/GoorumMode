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
        view.isAccessibilityElement = true
        view.accessibilityHint = "기분을 선택하려면 두 번 탭 하세요."
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
