//
//  ChartListTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/11/11.
//

import UIKit

final class ChartListTableViewCell: BaseTableViewCell {
    
    let iconImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let progressView = {
        let view = UIProgressView()
        view.progressTintColor = .systemPink
        view.trackTintColor = Constants.Color.Background.calendar
        view.progress = 0.5
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.sublayers![1].cornerRadius = 5
        view.subviews[1].clipsToBounds = true
        return view
    }()
    
    let label = {
        let view = UILabel()
        view.text = "999개"
        view.textAlignment = .right
        view.font = Constants.Font.regular(size: 14)
        view.textColor = Constants.Color.Text.basicTitle
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    override func configure() {
        [progressView, iconImageView, label].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-35)
            make.centerY.equalTo(iconImageView)
        }
        
        progressView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(10)
            make.center.equalToSuperview()
        }
    }
}
