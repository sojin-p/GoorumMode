//
//  ChartView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/13.
//

import UIKit
import FSCalendar

final class ChartView: BaseView {
    
    let calendar = {
        let view = BasicFSCalendar()
        view.scope = .week
        view.headerHeight = 50
        view.weekdayHeight = 40
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 18)
        return view
    }()
    
    //MARK: - Calendar Header
    private let headerView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.basic
        return view
    }()
    
    let headerLabel = {
        let view = UILabel()
        view.text = Date().toString(of: .yearAndMouth)
        view.textColor = Constants.Color.Text.basicTitle
        view.font = Constants.Font.extraBold(size: 18)
        return view
    }()
    
    private lazy var showMonthButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = Constants.Color.iconTint.unselected
        view.addTarget(self, action: #selector(showMonthButtonClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var backTodayButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 28), title: "오늘")
        view.tintColor = Constants.Color.iconTint.basicBlack
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.white
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = false
        return view
    }()
    
    //MARK: - Main Contents(Buttons, ChartTable)
    private let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.white
        view.roundCorners(cornerRadius: 70, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return view
    }()
    
    lazy var chartButtons = [dailyButton, weeklyButton, monthlyButton]
    
    private let dailyButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 32), title: "일간")
        view.tag = DateRange.daliy.rawValue
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.basic
        return view
    }()
    
    private let weeklyButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 32), title: "주간")
        view.tag = DateRange.weekly.rawValue
        return view
    }()
    
    private let monthlyButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 32), title: "월간")
        view.tag = DateRange.monthly.rawValue
        return view
    }()
    
    var dateRangeLabel = {
        let view = UILabel()
        view.text = "\(Date().toString(of: .dateForChart)) - \(Date().toString(of: .dateForChart))"
        view.font = Constants.Font.extraBold(size: 15)
        view.textColor = Constants.Color.Text.basicSubTitle
        view.textAlignment = .center
        view.numberOfLines = 3
        return view
    }()
    
    lazy var chartTableView = {
        let view = UITableView()
        view.rowHeight = 350
        view.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.reuseIdentifier)
        view.bounces = false
        view.separatorColor = .clear
        view.backgroundColor = Constants.Color.Background.white
        return view
    }()
    
    //MARK: - Calendar Swipe
    private lazy var swipeUp = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .up
        return view
    }()
    
    private lazy var swipeDown = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .down
        return view
    }()
    
    //MARK: - @objc func
    @objc private func swipedUpAndDown(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            calendar.setScope(.week, animated: true)
        } else if sender.direction == .down {
            calendar.setScope(.month, animated: true)
        }
    }
    
    @objc private func showMonthButtonClicked() {
        calendar.setScope(.month, animated: true)
    }
    
    @objc private func setChartButtons(_ sender: UIButton) {
        chartButtons.forEach { button in
            if sender == button {
                button.isSelected = true
                button.backgroundColor = Constants.Color.Background.basic
            } else {
                button.isSelected = false
                button.backgroundColor = Constants.Color.Background.white
            }
        }
    }
    
    //MARK: - hierarchies & Constraints
    override func configure() {
        super.configure()
        chartButtons.forEach { $0.addTarget(self, action: #selector(setChartButtons), for: .touchUpInside) }
        [calendar, headerView, backView, dailyButton, weeklyButton, monthlyButton, dateRangeLabel, chartTableView].forEach { addSubview($0) }
        [headerLabel, backTodayButton, showMonthButton].forEach { headerView.addSubview($0) }
        [swipeUp, swipeDown].forEach { calendar.addGestureRecognizer($0) }
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(400)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(calendar.calendarHeaderView)
            make.top.horizontalEdges.equalTo(calendar)
        }

        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        showMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.leading.equalTo(headerLabel.snp.trailing)
            make.size.equalTo(40)
        }

        backTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(28)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        weeklyButton.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(25)
            make.centerX.equalTo(backView)
            make.height.equalTo(32)
        }
        
        dailyButton.snp.makeConstraints { make in
            make.centerY.size.equalTo(weeklyButton)
            make.trailing.equalTo(weeklyButton.snp.leading).offset(-8)
        }
        
        monthlyButton.snp.makeConstraints { make in
            make.centerY.size.equalTo(weeklyButton)
            make.leading.equalTo(weeklyButton.snp.trailing).offset(8)
        }
        
        dateRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(weeklyButton.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        chartTableView.snp.makeConstraints { make in
            make.top.equalTo(dateRangeLabel.snp.bottom).offset(25)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

    }
}
