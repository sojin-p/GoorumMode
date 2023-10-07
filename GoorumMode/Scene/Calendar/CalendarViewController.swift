//
//  CalendarViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit
import FSCalendar

final class CalendarViewController: BaseViewController {
    
    var calendar = {
        let view = FSCalendar(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendar()
    }
    
    override func configure() {
        view.backgroundColor = Constants.Color.Background.basic
        view.addSubview(calendar)
    }
    
    override func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.65)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate,FSCalendarDataSource {
    
}

extension CalendarViewController {
    
    func setCalendar() {
        calendar.delegate = self
        calendar.dataSource = self

        calendar.headerHeight = 80
        calendar.weekdayHeight = 50
        
        calendar.appearance.headerTitleFont = Constants.Font.extraBold(size: 21)
        calendar.appearance.headerTitleColor = Constants.Color.Text.basicTitle
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = DateFormatType.yearAndMouth.description
        
        calendar.appearance.weekdayFont = Constants.Font.bold(size: 15)
        calendar.appearance.weekdayTextColor = Constants.Color.Text.basicSubTitle
        
        calendar.placeholderType = .none
        
        calendar.appearance.selectionColor = .systemGray4
        
        calendar.appearance.titleFont = Constants.Font.bold(size: 15)
        calendar.appearance.titleWeekendColor = Constants.Color.Text.basicTitle
        calendar.appearance.titleDefaultColor = Constants.Color.Text.basicTitle
        calendar.appearance.titleTodayColor = Constants.Color.Text.basicTitle
        
        calendar.appearance.todayColor = .systemGray6
        calendar.appearance.todaySelectionColor = .systemGray6
    }
    
}
