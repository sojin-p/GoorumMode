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
        let view = BasicFSCalendar()
        view.headerHeight = 60
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 18)
        return view
    }()
    
    private let headerView = {
        let view = CalendarHeaderView()
        return view
    }()
    
    let showDateButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "날짜만 보기")
        view.tintColor = Constants.Color.iconTint.basicBlack
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.white
        view.buttonShadow(radius: 3, opacity: 0.5)
        return view
    }()
    
    var completionHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.reloadData()
        
        showDateButton.addTarget(self, action: #selector(showDateButtonClicked), for: .touchUpInside)
        headerView.backTodayButton.addTarget(self, action: #selector(backTodayButtonClicked), for: .touchUpInside)
        headerView.showMonthButton.addTarget(self, action: #selector(showMonthButtonClicked), for: .touchUpInside)
    }
    
    @objc private func showMonthButtonClicked() {
        print("클릭")
    }
    
    @objc func showDateButtonClicked() {
        let visibleCells = calendar.visibleCells()
        
        visibleCells.forEach { cell in
            if let cell = cell as? FSCalendarCustomCell {
                cell.moodImageView.image = nil
            }
        }
    }
    
    @objc private func backTodayButtonClicked() {
        calendar.select(Date())
    }
    
    override func configure() {
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.reuseIdentifier)
        view.backgroundColor = Constants.Color.Background.basic
        [calendar, headerView, showDateButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(calendar.calendarHeaderView)
            make.top.horizontalEdges.equalTo(calendar)
        }
        
        showDateButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.centerX.equalTo(calendar)
            make.height.equalTo(30)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
    
    func getMostMood(year: Int, month: Int) -> [Date: String] {
        
        let moodsForMonth = MoodRepository.shared.fetchMonth(year: year, month: month)
        
        let groupedMoods = Dictionary(grouping: moodsForMonth) { Calendar.current.startOfDay(for: $0.date) }
        
        var mostMoods: [Date: String] = [:]
        
        for (date, moods) in groupedMoods {
            let moodCounts = MoodRepository.shared.countMoods(moods: moods)
            
            var maxKeys: [String] = []
            if let maxValue = moodCounts.values.max() {
                maxKeys = moodCounts.filter({ $0.value == maxValue }).map({ $0.key })
            }
            
            if maxKeys.count == 1 {
                mostMoods[date] = maxKeys.first
            } else {
                if let recentMood = moods.max(by: { $0.date < $1.date })?.mood {
                    mostMoods[date] = recentMood
                }
            }
        }
        
        return mostMoods
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.reuseIdentifier, for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
        let currentPage = calendar.currentPage
        let year = Calendar.current.component(.year, from: currentPage)
        let month = Calendar.current.component(.month, from: currentPage)
        
        let mostMoods: [Date: String] = getMostMood(year: year, month: month)
        
        if mostMoods.keys.contains(date) {
            cell.moodImageView.image = UIImage(named: mostMoods[date] ?? MoodEmojis.placeholder)
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        completionHandler?(date)
        navigationController?.popViewController(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date > Date() {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date > Date() {
            return Constants.Color.Text.basicPlaceholder
        } else {
            return nil
        }
    }
}
