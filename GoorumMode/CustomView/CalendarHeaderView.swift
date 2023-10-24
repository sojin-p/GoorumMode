//
//  CalendarHeaderView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/16.
//

import UIKit

final class CalendarHeaderView: BaseView {
    
    let headerLabel = {
        let view = UILabel()
        view.text = Date().toString(of: .yearAndMouth)
        view.textColor = Constants.Color.Text.basicTitle
        view.font = Constants.Font.extraBold(size: 18)
        view.isUserInteractionEnabled = true
        view.accessibilityTraits = .none
        return view
    }()
    
    let showMonthButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = Constants.Color.iconTint.unselected
        view.accessibilityElementsHidden = true
        return view
    }()
    
    let backTodayButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 28), title: "backTodayButton_Title".localized)
        view.tintColor = Constants.Color.iconTint.basicBlack
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.white
        view.buttonShadow(radius: 3, opacity: 0.5)
        view.accessibilityElementsHidden = true
        return view
    }()
    
    override func configure() {
        backgroundColor = Constants.Color.Background.calendar
        [headerLabel, backTodayButton, showMonthButton].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        showMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.leading.equalTo(headerLabel.snp.trailing)
            make.size.equalTo(headerLabel.snp.height)
        }

        backTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(28)
        }
    }
}
