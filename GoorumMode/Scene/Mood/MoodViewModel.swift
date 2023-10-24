//
//  MoodViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/05.
//

import Foundation

final class MoodViewModel {
    
    let moodRepository = MoodRepository()
    lazy var moods: Observable<[Mood]> = Observable(moodRepository.fetch(dateRange: .daliy))
    
    var selectedDate: Observable<Date> = Observable(Date())
    
    func fetchSelectedDate(_ date: Date) {
        moods.value = moodRepository.fetch(dateRange: .daliy, selectedDate: date)
        selectedDate.value = date
    }
    
    func append(_ data: Mood) {
        moods.value.append(data)
        moods.value.sort { $0.date > $1.date }
    }
    
    func update(idx: Int, data: Mood) {
        moods.value[idx] = data
        moods.value.sort { $0.date > $1.date }
    }
    
    func remove(idx: Int) {
        moods.value.remove(at: idx)
    }

}
