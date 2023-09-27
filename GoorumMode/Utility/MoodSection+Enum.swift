//
//  MoodSection+Enum.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/27.
//

import Foundation

enum Section {
    
    case today
    
    var header: String {
        switch self {
        case .today: return "2023.01.01 월요일"
        }
    }
    
}
