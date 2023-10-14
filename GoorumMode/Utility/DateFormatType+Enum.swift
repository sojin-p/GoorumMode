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
    case yearAndMouth
    case dateForTitle
    case dateForChart
    
    var description: String {
        switch self {
        case .detailedDate: return "yyyy.MM.dd. a hh:mm:ss"
        case .timeWithoutSecond: return "a hh:mm"
        case .yearAndMouth: return "yyyy년 MM월"
        case .dateForTitle: return "yyyy.MM.dd. EEEE"
        case .dateForChart: return "yyyy.MM.dd."
        }
    }
}
