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
        view.contentMode = .scaleAspectFit
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
        view.font = Constants.Font.extraBold(size: 15)
        return view
    }()
    
    let onelineLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.Text.basicTitle
        view.font = Constants.Font.regular(size: 15)
        if let text = view.text, text.isEmpty {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    lazy var detailBackView = {
        let view = UILabel()
        if let text = detailLabel.text, text.isEmpty {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        return view
    }()
    
    let detailLabel = {
        let view = UILabel()
        view.font = Constants.Font.regular(size: 15)
        view.numberOfLines = 0
        view.textColor = Constants.Color.Text.basicTitle
        view.setLineSpacing(spacing: 5)
        return view
    }()
    
    override func configure() {
        contentView.backgroundColor = Constants.Color.Background.white
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(baseStackView)
        [containerView, detailBackView].forEach { baseStackView.addArrangedSubview($0) }
        detailBackView.addSubview(detailLabel)
        [moodImageView, timeStackView].forEach { containerView.addSubview($0) }
        [timeLabel, onelineLabel].forEach { timeStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(15)
        }

        containerView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        moodImageView.snp.makeConstraints { make in
            make.size.equalTo(containerView.snp.height)
            make.leading.centerY.equalToSuperview()
        }

        timeStackView.snp.makeConstraints { make in
            make.leading.equalTo(moodImageView.snp.trailing).offset(12)
            make.centerY.trailing.equalToSuperview()
        }
        
    }
}
