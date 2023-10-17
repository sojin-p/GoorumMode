//
//  SelectDatePickerViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/17.
//

import UIKit

final class SelectDatePickerViewController: BaseViewController {
    
    let pickerView = {
        let view = UIPickerView()
        return view
    }()
    
    let doneButton = {
        let view = UIButton()
        view.setTitle("완료", for: .normal)
        view.setTitleColor(Constants.Color.iconTint.basicWhite, for: .normal)
        view.setTitleColor(Constants.Color.iconTint.basicWhite, for: [.normal, .highlighted])
        view.backgroundColor = Constants.Color.iconTint.basicBlack
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Constants.Font.bold(size: 15)
        return view
    }()
    
    var years: [Int] = []
    let months: [Int] = Array(1...12)
    var selectedDate: Date?
    lazy var selectedYear = Calendar.current.component(.year, from: selectedDate ?? Date())
    lazy var selectedMonth = Calendar.current.component(.month, from: selectedDate ?? Date())
    let currentYear = Calendar.current.component(.year, from: Date())
    var completionHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for year in (currentYear - 20)...currentYear {
            years.append(year)
        }
        
        setupSheet([.custom(resolver: { context in
            300
        })], isModal: false)
        
        view.backgroundColor = Constants.Color.Background.basic
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.selectRow(selectedYear - (currentYear - 20), inComponent: 0, animated: true)
        pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: true)
    }
    
    override func configure() {
        [doneButton, pickerView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        pickerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(doneButton).inset(-5)
            make.bottom.equalTo(doneButton.snp.top).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    @objc func doneButtonClicked() {
        completionHandler?(selectedDate ?? Date())
        dismiss(animated: true)
    }
    
}

extension SelectDatePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return years.count
        case 1: return months.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(years[row])년"
        case 1: return "\(months[row])월"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            selectedYear = selectedYear + (row - 20)
        } else if component == 1 {
            selectedMonth = row + 1
        }
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate ?? Date())
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth
        
        if let date = calendar.date(from: dateComponents) {
            selectedDate = date
        }
        
    }
    
}
