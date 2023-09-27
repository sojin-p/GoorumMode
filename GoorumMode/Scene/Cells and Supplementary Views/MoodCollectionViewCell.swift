//
//  MoodCollectionViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class MoodCollectionViewCell: BaseCollectionViewCell {
    
    private let baseStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        view.backgroundColor = .blue
        return view
    }()
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let moodImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let timeStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 0
        view.backgroundColor = .systemPink
        return view
    }()
    
    let timeLabel = {
        let view = UILabel()
        view.text = "23:00"
        view.backgroundColor = .yellow
        view.textColor = Constants.Color.Text.basicSubTitle
        return view
    }()
    
    let onelineLabel = {
        let view = UILabel()
        view.text = "Hi, How are you?"
        view.textColor = Constants.Color.Text.basicTitle
        if view.text == nil {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    let detailLabel = {
        let view = UILabel()
        view.text = "detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail"
        view.numberOfLines = 0
        view.backgroundColor = .cyan
        view.textColor = Constants.Color.Text.basicTitle
        if view.text == nil {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    override func configure() {
        contentView.addSubview(baseStackView)
        [containerView, detailLabel].forEach { baseStackView.addArrangedSubview($0) }
        [moodImageView, timeStackView].forEach { containerView.addSubview($0) }
        [timeLabel, onelineLabel].forEach { timeStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.horizontalEdges.equalToSuperview()
        }
        
        moodImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.centerY.equalToSuperview()
        }
        
        timeStackView.snp.makeConstraints { make in
            make.leading.equalTo(moodImageView.snp.trailing).offset(10)
            make.verticalEdges.centerY.trailing.equalToSuperview()
        }
        
    }
}
