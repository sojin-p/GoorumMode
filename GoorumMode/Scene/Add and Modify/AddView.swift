//
//  AddView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddView: BaseView {
    
    let detailTextView = {
        let view = UITextView()
        view.backgroundColor = .brown
        view.font = .systemFont(ofSize: 17)
        view.isHidden = true
        return view
    }()
    
    let containerView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    let pickMoodImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.isAccessibilityElement = true
        view.accessibilityLabel = "기분 선택"
        view.accessibilityTraits = .button
        view.accessibilityHint = "기분을 선택하려면 두 번 탭 하세요."
        return view
    }()
    
    let timeBackView = {
        let view = UIView()
        view.backgroundColor = .yellow
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
        view.backgroundColor = .purple
        return view
    }()
    
    let extendButton = {
        let view = UIButton()
        view.accessibilityLabel = "내용 추가"
        view.accessibilityHint = "자세한 내용 또는 일기를 작성하려면 두 번 탭 하세요."
        return view
    }()
    
    override func configure() {
        [containerView, detailTextView].forEach { addSubview($0) }
        [pickMoodImageView, timeBackView].forEach { containerView.addSubview($0) }
        [timePicker, oneLineTextField, extendButton].forEach { timeBackView.addSubview($0) }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        pickMoodImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.leading.centerY.equalToSuperview()
        }
        
        timeBackView.snp.makeConstraints { make in
            make.leading.equalTo(pickMoodImageView.snp.trailing).offset(10)
            make.verticalEdges.centerY.trailing.equalToSuperview()
        }
        
        extendButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.trailing.bottom.equalToSuperview()
        }
        
        oneLineTextField.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(extendButton.snp.leading)
            make.height.equalTo(extendButton)
        }
        
        timePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
}
