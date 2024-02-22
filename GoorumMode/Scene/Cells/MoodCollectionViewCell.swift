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
        view.spacing = 0
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
        view.textColor = Constants.Color.Text.basicSubTitle
        view.font = Constants.Font.bold(size: 15)
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
    
    let detailLabel = {
        let view = PaddingLabel()
        view.font = Constants.Font.regular(size: 15)
        view.numberOfLines = 0
        view.textColor = Constants.Color.Text.basicTitle
        return view
    }()
    
    private func applyAccessibility() {
        isAccessibilityElement = true
        [timeLabel, detailLabel, onelineLabel].forEach { $0.isAccessibilityElement = false }
    }
    
    func configureCell(_ itemIdentifier: Mood, dateType: DateFormatType) {
        moodImageView.image = UIImage(named: itemIdentifier.mood)
        timeLabel.text = itemIdentifier.date.toString(of: dateType)
        
        if let onelineText = itemIdentifier.onelineText, onelineText.isEmpty {
            onelineLabel.isHidden = true
        } else {
            onelineLabel.text = itemIdentifier.onelineText
            onelineLabel.isHidden = false
        }
        
        if let detailText = itemIdentifier.detailText, detailText.isEmpty {
            detailLabel.isHidden = true
        } else {
            detailLabel.text = itemIdentifier.detailText
            detailLabel.isHidden = false
        }
        
        detailLabel.setLineSpacing(spacing: 5)
    }
    
    func setCellAccessibility(_ itemIdentifier: Mood, accessibilityDateType: DateFormatType) {

        let isEmptyString = "cellRegistration_AccessibilityLabel_isEmpty".localized
        let timeAccessibilityLabel = itemIdentifier.date.toString(of: accessibilityDateType)
        let moodAccessibilityLabel = MoodEmojis(rawValue: itemIdentifier.mood)?.accessLabel ?? isEmptyString
        
        let value = NSLocalizedString("cellRegistration_AccessibilityLabel", comment: "")
        accessibilityLabel = String(format: value, timeAccessibilityLabel, moodAccessibilityLabel, (onelineLabel.text ?? isEmptyString), (detailLabel.text ?? isEmptyString))
    }
    
    override func configure() {
        applyAccessibility()
        
        contentView.backgroundColor = Constants.Color.Background.white
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(baseStackView)
        [containerView, detailLabel].forEach { baseStackView.addArrangedSubview($0) }
        [moodImageView, timeStackView].forEach { containerView.addSubview($0) }
        [timeLabel, onelineLabel].forEach {
            timeStackView.addArrangedSubview($0) }
        containerView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
    }
    
    override func setConstraints() {
        
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(15)
        }

        containerView.snp.makeConstraints { make in
            make.height.equalTo(70)
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
