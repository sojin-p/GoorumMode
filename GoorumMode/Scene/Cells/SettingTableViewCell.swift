//
//  SettingTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2024/02/24.
//

import UIKit

final class SettingTableViewCell: BaseTableViewCell {
    
    private let iconImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    var switchValueChangedHandler: ((Bool) -> Void)?
    
    let notiSwitch = {
        let view = UISwitch()
        view.onTintColor =  Constants.Color.Background.basicIcon
        view.thumbTintColor = Constants.Color.iconTint.basicWhite
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconImageView.isHidden = false
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.font = Constants.Font.bold(size: 15)
        titleLabel.textColor = Constants.Color.Text.basicTitle
        iconImageView.tintColor = Constants.Color.iconTint.basicBlack
        backgroundColor = Constants.Color.Background.basic
        
        if iconImageView.image == nil {
            updateLayout(true)
        } else {
            updateLayout(false)
        }
        
    }
    
    func configureCell(_ row: Setting) {
        
        titleLabel.text = row.title.localized()
        iconImageView.image = row.mainIcon
        
        if row.hasSwitch {
            notiSwitch.isHidden = false
        } else {
            notiSwitch.isHidden = true
        }
        
    }
    
    func configureInfoCell() {
        titleLabel.text = "setting_PrivacyPolicy".localized
    }
    
    override func configure() {
        [iconImageView, titleLabel, notiSwitch].forEach { contentView.addSubview($0) }
        notiSwitch.addTarget(self, action: #selector(notiSwitchValueChanged), for: .valueChanged)
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
        
        notiSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
        }
        
    }
    
    @objc func notiSwitchValueChanged(_ sender: UISwitch) {
        
            print("=======>>>>>>>", sender.isOn)
            switchValueChangedHandler?(sender.isOn)
        
    }
    
    private func updateLayout(_ isNil: Bool) {
        if isNil {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalTo(iconImageView)
                make.trailing.equalToSuperview().offset(-15)
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(8)
                make.centerY.equalTo(iconImageView)
                make.trailing.equalToSuperview().offset(-15)
            }
        }
    }
}

