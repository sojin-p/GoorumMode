//
//  CalendarViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit
import FSCalendar

final class CalendarViewController: BaseViewController {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.Background.basic
        view.layer.cornerRadius = 25
        return view
    }()
    
    var calendar = {
        let view = BasicFSCalendar()
        view.headerHeight = 70
        view.weekdayHeight = 45
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 20)
        return view
    }()
    
    var completionHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.reloadData()
    }
    
    override func configure() {
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.identifier)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.addSubview(backView)
        backView.addSubview(calendar)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
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
            var moodCounts: [String: Int] = [:]
            for mood in moods {
                let mood = mood.mood
                if moodCounts.keys.contains(mood) {
                    moodCounts[mood] = (moodCounts[mood] ?? 0) + 1
                } else {
                    moodCounts[mood] = 1
                }
            }
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

extension CalendarViewController: FSCalendarDelegate,FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.identifier, for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
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
        dismiss(animated: false)
    }
}
