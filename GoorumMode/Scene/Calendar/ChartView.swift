//
//  ChartView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/13.
//

import UIKit
import FSCalendar
import DGCharts

final class ChartView: BaseView {
    
    let calendar = {
        let view = BasicFSCalendar()
        view.scope = .week
        view.headerHeight = 45
        view.weekdayHeight = 40
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 17)
        return view
    }()
    
    private let headerView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.basic
        return view
    }()
    
    private let headerLabel = {
        let view = UILabel()
        view.text = "2023년 10월"
        view.textColor = Constants.Color.Text.basicTitle
        view.font = Constants.Font.extraBold(size: 18)
        return view
    }()
    
    let previousButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        view.tintColor = Constants.Color.iconTint.basicBlack
        return view
    }()
    
    let nextButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = Constants.Color.iconTint.basicBlack
        return view
    }()
    
    let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.white
        view.roundCorners(cornerRadius: 70, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return view
    }()
    
    let todayChartButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "일간")
        view.isSelected = true
        return view
    }()
    
    let weekChartButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "주간")
        return view
    }()
    
    let monthChartButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "월간")
        return view
    }()
    
    let pieChartView = {
        let view = PieChartView()
        view.noDataText = "작성된 기분이 없습니다."
        view.noDataFont = Constants.Font.extraBold(size: 16)
        view.noDataTextColor = Constants.Color.Text.basicPlaceholder!
        view.drawHoleEnabled = false
        view.legend.enabled = false
        view.usePercentValuesEnabled = true
        return view
    }()
    
    lazy var swipeUp = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .up
        return view
    }()
    
    lazy var swipeDown = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .down
        return view
    }()
    
    @objc func swipedUpAndDown(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            calendar.setScope(.week, animated: true)
        } else if sender.direction == .down {
            calendar.setScope(.month, animated: true)
        }
    }
    
    override func configure() {
        super.configure()
        [calendar, headerView, backView, todayChartButton, weekChartButton, monthChartButton, pieChartView].forEach { addSubview($0) }
        [headerLabel, nextButton, previousButton].forEach { headerView.addSubview($0) }
        [swipeUp, swipeDown].forEach { calendar.addGestureRecognizer($0) }
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(350)
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
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalTo(nextButton.snp.leading)
            make.size.equalTo(40)
        }

        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().offset(-7)
            make.size.equalTo(40)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        weekChartButton.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(20)
            make.centerX.equalTo(backView)
            make.height.equalTo(30)
        }
        
        todayChartButton.snp.makeConstraints { make in
            make.centerY.size.equalTo(weekChartButton)
            make.trailing.equalTo(weekChartButton.snp.leading).offset(-8)
        }
        
        monthChartButton.snp.makeConstraints { make in
            make.centerY.size.equalTo(weekChartButton)
            make.leading.equalTo(weekChartButton.snp.trailing).offset(8)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(weekChartButton.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(25)
        }
    }
}
