//
//  MoodViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/05.
//

import Foundation

final class MoodViewModel {
    
    var moods: Observable<[Mood]> = Observable(MoodRepository.shared.fetch(dateRange: .daliy))
    
}
