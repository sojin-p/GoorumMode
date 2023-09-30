//
//  DateFormatType+Enum.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/30.
//

import Foundation

enum DateFormatType {
    case detailedDate
    case timeWithoutSecond
    case yearAndMouth, onlyDay
    case dateForTitle
    
    var description: String {
        switch self {
        case .detailedDate: return "yyyy.MM.dd. a hh:mm:ss"
        case .timeWithoutSecond: return "a hh:mm"
        case .yearAndMouth: return "yyyy.MM"
        case .onlyDay: return "dd"
        case .dateForTitle: return "yyyy.MM.dd EEEE"
        }
    }
}
