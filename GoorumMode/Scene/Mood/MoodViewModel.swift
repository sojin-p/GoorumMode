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
    
}
