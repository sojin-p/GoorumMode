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
        view.headerHeight = 80
        view.weekdayHeight = 45
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 21)
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    override func configure() {
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.identifier)
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
    
    func getMostMood(year: Int, month: Int) -> [Date: String] {
        
        let moodsForMonth = MoodRepository.shared.fetchMonth(year: year, month: month)
        
        let groupedMoods = Dictionary(grouping: moodsForMonth) { Calendar.current.startOfDay(for: $0.date) }
        
        var mostMoods: [Date: String] = [:] //날짜당 최다기분 or 최근 기분
        
        for (date, moods) in groupedMoods {
//            print("그룹된날짜: ", date)
            var moodCounts: [String: Int] = [:] //기분당 갯수
            for mood in moods {
                let mood = mood.mood
                if moodCounts.keys.contains(mood) {
                    moodCounts[mood] = (moodCounts[mood] ?? 0) + 1
                } else {
                    moodCounts[mood] = 1
                }
            }
//            print("기분갯수 체크: ",moodCounts)
            
            //가장 많은 기분을 찾고, 여러개면 최근 값으로
            var maxKeys: [String] = []
            if let maxValue = moodCounts.values.max() {
                maxKeys = moodCounts.filter({ $0.value == maxValue }).map({ $0.key })
            }
            
            if maxKeys.count == 1 {
                mostMoods[date] = maxKeys.first
            } else {
                //최근 거 찾기
                if let recentMood = moods.max(by: { $0.date < $1.date })?.mood {
                    mostMoods[date] = recentMood
                }
            }
        }
//        print("최다 기분:",mostMoods)
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
        
        let test = getMostMood(year: year, month: month)
        
        if test.keys.contains(date) {
            cell.moodImageView.image = UIImage(named: test[date] ?? MoodEmojis.placeholder)
        }
        
        return cell
    }
}