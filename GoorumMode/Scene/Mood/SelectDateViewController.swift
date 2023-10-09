//
//  SelectDateViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/09.
//

import UIKit
import FSCalendar

final class SelectDateViewController: BaseViewController {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.basic
        view.layer.cornerRadius = 25
        return view
    }()
    
    let calendar = {
        let view = BasicFSCalendar()
        view.headerHeight = 50
        view.weekdayHeight = 40
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 17)
        return view
    }()
    
    var completionHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    override func configure() {
        view.addSubview(backView)
        backView.addSubview(calendar)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
}

extension SelectDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("선택된 날짜 : ", date)
        completionHandler?(date)
        dismiss(animated: false)
    }
}
