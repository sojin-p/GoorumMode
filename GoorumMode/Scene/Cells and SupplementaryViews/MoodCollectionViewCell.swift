//
//  MoodCollectionViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class MoodCollectionViewCell: BaseCollectionViewCell {
    
    private let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let baseStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 12
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let containerView = {
        let view = UIView()
        return view
    }()
    
    let moodImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.isAccessibilityElement = true
        view.accessibilityLabel = "기분"
        return view
    }()
    
    private let timeStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let timeLabel = {
        let view = UILabel()
        view.text = "23:30"
        view.accessibilityLabel = "\(view.text!)시간에 등록했습니다."
        view.textColor = Constants.Color.Text.basicSubTitle
        view.font = Constants.Font.extraBold(size: 14)
        return view
    }()
    
    let onelineLabel = {
        let view = UILabel()
        view.text = "Hi, How are you?"
        view.textColor = Constants.Color.Text.basicTitle
        view.font = Constants.Font.regular(size: 14)
        if view.text == nil {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    let detailLabel = {
        let view = UILabel()
        view.text = "오늘의 일기는 어쩌고 저쩌고해서 이랬다. 그리고 어쩌구군ㅇㄴ아ㅓ룸루했고 ㅁㅈ누이ㅏㅁㄴㄹㅇ여서 ㄴㅇ물니ㅏㅁ두라ㅣ였다.!"
        view.font = Constants.Font.regular(size: 14)
        view.numberOfLines = 0
        view.textColor = Constants.Color.Text.basicTitle
        view.setLineSpacing(spacing: 4)
        if view.text == nil {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    override func configure() {
        contentView.addSubview(backView)
        backView.addSubview(baseStackView)
        [containerView, detailLabel].forEach { baseStackView.addArrangedSubview($0) }
        [moodImageView, timeStackView].forEach { containerView.addSubview($0) }
        [timeLabel, onelineLabel].forEach { timeStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(15)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(5)
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
            make.leading.equalTo(moodImageView.snp.trailing).offset(12)
            make.centerY.trailing.equalToSuperview()
        }
        
    }
}
