//
//  CalendarViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/21.
//

import Foundation

final class CalendarViewModel {
    
    var currentDate: Observable<Date> = Observable(Date())
    let moodRepository = MoodRepository()
    
    var isShowed = Observable(false)
    
    func showDateButtonClicked(selectedDate: Date, calendar: BasicFSCalendar) {
        isShowed.value.toggle()
        if isShowed.value {
            if selectedDate != Calendar.current.startOfDay(for: Date()) {
                calendar.appearance.todayColor = .clear
            }
        }
        calendar.reloadData()
    }
    
    func showMoodImagesOnCell(date: Date, completionHanlder: @escaping (String) -> Void) {
        if !isShowed.value {
            
            let mostMoods: [Date: String] = getMostMood(date: date)
            
            if mostMoods.keys.contains(date) {
                completionHanlder(mostMoods[date] ?? MoodEmojis.placeholder)
            }
            
        }
    }
    
    func getMostMood(date: Date) -> [Date: String] {
        
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let moodsForMonth = moodRepository.fetchMonth(year: year, month: month)
        
        let groupedMoods = Dictionary(grouping: moodsForMonth) { Calendar.current.startOfDay(for: $0.date) }
        
        var mostMoods: [Date: String] = [:]
        
        for (date, moods) in groupedMoods {
            let moodCounts = moodRepository.countMoods(moods: moods)
            
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
