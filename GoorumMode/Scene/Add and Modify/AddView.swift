//
//  AddView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/28.
//

import UIKit

final class AddView: BaseView {
    
    let detailTextViewPlaceholder = "detailTextView_Placeholder".localized
    lazy var detailTextView = {
        let view = UITextView()
        view.backgroundColor = Constants.Color.Background.basic
        view.isHidden = true
        view.setLineSpacing(text: self.detailTextViewPlaceholder, spacing: 6)
        view.textColor = Constants.Color.Text.basicPlaceholder
        view.font = Constants.Font.regular(size: 15)
        return view
    }()
    
    private let containerView = {
        let view = UIView()
        return view
    }()
    
    let pickMoodPlaceholder = UIImage(named: MoodEmojis.placeholder)
    lazy var pickMoodImageView = {
        let view = UIImageView()
        view.image = pickMoodPlaceholder
        view.contentMode = .scaleAspectFit
        view.isAccessibilityElement = true
        view.accessibilityLabel = "pickMoodImageView_AccessibilityLabel".localized
        view.accessibilityTraits = .button
        view.accessibilityHint = "pickMoodImageView_AccessibilityHint".localized
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let timeBackView = {
        let view = UIView()
        return view
    }()
    
    let timePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .compact
        view.contentHorizontalAlignment = .leading
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        let maxTime = calendar.date(byAdding: components, to: Date())
        view.maximumDate = maxTime
        return view
    }()
    
    let oneLineTextField = {
        let view = UITextField()
        view.placeholder = "oneLineTextField_Placeholder".localized
        view.font = Constants.Font.regular(size: 15)
        view.addLeftPadding()
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    private let underLineView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.iconTint.basicBlack
        return view
    }()
    
    let extendButton = ExtendButton()
    
    var doneBarButton = {
        let view = UIBarButtonItem()
        view.accessibilityLabel = "doneBarButton_AccessibilityLabel".localized
        view.accessibilityHint = "doneBarButton_AccessibilityHint".localized
        return view
    }()
    var removeBarButton = {
        let view = UIBarButtonItem()
        view.accessibilityLabel = "removeBarButton_AccessibilityLabel".localized
        view.accessibilityHint = "removeBarButton_AccessibilityHint".localized
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
            make.bottom.greaterThanOrEqualTo(keyboardLayoutGuide.snp.top).offset(-15)
        }
    }
    
}
