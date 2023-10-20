//
//  SelectDateViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/20.
//

import UIKit

final class SelectDateViewController: BaseViewController {
    
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
    }
    
    override func configure() {
        super.configure()
        [doneButton, datePicker].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(doneButton)
            make.bottom.equalTo(doneButton.snp.top).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    @objc func doneButtonClicked() {        completionHandler?(selectedDate ?? Date())
        dismiss(animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        print("선택됨: ", sender.date)
        selectedDate = sender.date
    }
}
