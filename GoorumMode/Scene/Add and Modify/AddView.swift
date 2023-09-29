//
//  AddView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddView: BaseView {
    
    let detailTextViewPlaceholder = "자세한 내용을 기록해 보세요."
    lazy var detailTextView = {
        let view = UITextView()
        view.backgroundColor = Constants.Color.Background.basic
        view.font = Constants.Font.regular(size: 15)
        view.isHidden = true
        view.text = self.detailTextViewPlaceholder
        view.textColor = Constants.Color.Text.basicPlaceholder
        return view
    }()
    
    let containerView = {
        let view = UIView()
        return view
    }()
    
    let pickMoodImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Mood_Placeholder")
        view.contentMode = .scaleAspectFit
        view.isAccessibilityElement = true
        view.accessibilityLabel = "기분 선택"
        view.accessibilityTraits = .button
        view.accessibilityHint = "기분을 선택하려면 두 번 탭 하세요."
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let timeBackView = {
        let view = UIView()
        return view
    }()
    
    let timePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .compact
        view.contentHorizontalAlignment = .leading
        return view
    }()
    
    let oneLineTextField = {
        let view = UITextField()
        view.placeholder = "기분을 선택한 이유(15자)"
        view.font = Constants.Font.regular(size: 15)
        view.addLeftPadding()
        return view
    }()
    
    let underLineView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.iconTint.basicBlack
        return view
    }()
    
    let extendButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.width / 2
            view.setImage(UIImage(systemName: "plus"), for: .normal)
            view.tintColor = Constants.Color.iconTint.basicBlack
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            view.backgroundColor = Constants.Color.Background.white
        }
        view.accessibilityLabel = "내용 추가"
        view.accessibilityHint = "자세한 내용 또는 일기를 작성하려면 두 번 탭 하세요."
        return view
    }()
    
    override func configure() {
        [containerView, detailTextView].forEach { addSubview($0) }
        [pickMoodImageView, timeBackView].forEach { containerView.addSubview($0) }
        [timePicker, oneLineTextField, underLineView, extendButton].forEach { timeBackView.addSubview($0) }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        pickMoodImageView.snp.makeConstraints { make in
            make.size.equalTo(containerView.snp.height)
            make.leading.centerY.equalToSuperview()
        }
        
        timeBackView.snp.makeConstraints { make in
            make.leading.equalTo(pickMoodImageView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        extendButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(oneLineTextField)
        }
        
        oneLineTextField.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(extendButton.snp.leading).offset(-5)
            make.height.equalTo(35)
            make.top.equalTo(timePicker.snp.bottom).offset(4)
        }
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(oneLineTextField.snp.bottom)
            make.height.equalTo(1.2)
            make.horizontalEdges.equalTo(oneLineTextField)
        }
        
        timePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(33)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(25)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-15)
        }
    }
    
}
