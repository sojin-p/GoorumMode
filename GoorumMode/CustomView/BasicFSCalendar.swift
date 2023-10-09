//
//  BasicFSCalendar.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/09.
//

import UIKit
import FSCalendar

final class BasicFSCalendar: FSCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCalendar()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCalendar() {
        appearance.headerTitleColor = Constants.Color.Text.basicTitle
        appearance.headerMinimumDissolvedAlpha = 0.0
        appearance.headerDateFormat = DateFormatType.yearAndMouth.description
        
        appearance.weekdayFont = Constants.Font.bold(size: 15)
        appearance.weekdayTextColor = Constants.Color.Text.basicSubTitle
        
        placeholderType = .none
        
        appearance.selectionColor = .clear
        
        appearance.titleFont = Constants.Font.bold(size: 15)
        appearance.titleWeekendColor = Constants.Color.Text.basicTitle
        appearance.titleDefaultColor = Constants.Color.Text.basicTitle
        appearance.titleTodayColor = Constants.Color.Text.basicTitle
        appearance.titleSelectionColor = Constants.Color.Text.basicTitle
        
        appearance.todayColor = .systemGray4
    }
}
