//
//  SelectDateViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/20.
//

import UIKit

final class SelectDateViewController: BaseViewController {
    
    let backTodayButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "backTodayButton_Title".localized)
        view.tintColor = Constants.Color.iconTint.basicBlack
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.white
        view.buttonShadow(radius: 3, opacity: 0.5)
        view.accessibilityLabel = "backTodayButton_AccessibilityLabel".localized
        view.accessibilityTraits = .button
        view.accessibilityHint = "backTodayButton_AccessibilityHint".localized
        return view
    }()
    
    lazy var datePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        let maxDate = calendar.date(byAdding: components, to: Date())
        let miniDate = calendar.date(byAdding: .year, value: -20, to: Date())
        view.maximumDate = maxDate
        view.minimumDate = miniDate
        view.date = selectedDate ?? Date()
        return view
    }()
    
    let doneButton = {
        let view = UIButton()
        view.setTitle("doneButton_Title".localized, for: .normal)
        view.setTitleColor(Constants.Color.iconTint.basicWhite, for: .normal)
        view.setTitleColor(Constants.Color.iconTint.basicWhite, for: [.normal, .highlighted])
        view.backgroundColor = Constants.Color.iconTint.basicBlack
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Constants.Font.bold(size: 15)
        view.accessibilityHint = "doneButton_AccessibilityHint".localized
        return view
    }()
    
    var selectedDate: Date?
    var completionHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSheet([.custom(resolver: { context in
            300
        })], isModal: false)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        backTodayButton.addTarget(self, action: #selector(backTodayButtonTapped), for: .touchUpInside)
    }
    
    override func configure() {
        super.configure()
        [doneButton, datePicker, backTodayButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(doneButton).inset(-5)
            make.bottom.equalTo(doneButton.snp.top).offset(-10)
            make.top.equalTo(backTodayButton.snp.bottom).offset(10)
        }
        
        backTodayButton.snp.makeConstraints { make in
            make.trailing.equalTo(doneButton)
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
    }
    
    @objc func backTodayButtonTapped() {
        datePicker.date = Date()
        selectedDate = Date()
    }
    
    @objc func doneButtonClicked() {
        completionHandler?(selectedDate ?? Date())
        dismiss(animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
}
