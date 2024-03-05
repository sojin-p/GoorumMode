//
//  SettingTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

import UIKit

final class SettingTableViewCell: BaseTableViewCell {
    
    private let iconImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let titleLabel = {
        let view = UILabel()
        return view
    }()
    
    override func prepareForReuse() {
        iconImageView.image = nil
        iconImageView.isHidden = false
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        titleLabel.font = Constants.Font.bold(size: 15)
        titleLabel.textColor = Constants.Color.Text.basicTitle
        iconImageView.tintColor = Constants.Color.iconTint.basicBlack
        backgroundColor = Constants.Color.Background.basic
        selectionStyle = .none
        
        if iconImageView.image == nil {
            updateLayout()
        }
    }
    
    func configureCell(_ row: Setting) {
        titleLabel.text = row.title
        iconImageView.image = row.mainIcon
    }
    
    func configureInfoCell() {
        titleLabel.text = "setting_PrivacyPolicy".localized
    }
    
    override func configure() {
        [iconImageView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(9)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(iconImageView)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    private func updateLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(iconImageView)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}

