//
//  CalendarViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/21.
//

import Foundation

final class CalendarViewModel {
    
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
                
                let recent = moods.sorted { $0.date > $1.date }.map { $0.mood }
                
                if let recentMood = recent.first(where: { maxKeys.contains($0) }) {
                    mostMoods[date] = recentMood
                }
            }
        }
        
        return mostMoods
    }
    
}
