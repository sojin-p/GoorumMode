//
//  DateFormatType+Enum.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/30.
//

import Foundation

enum DateFormatType {
    case timeWithoutSecond
    case yearAndMouth
    case dateForTitle
    case dateForChart
    case timeForAccessibility
    
    var description: String {
        switch self {
        case .timeWithoutSecond: return "a hh:mm"
        case .yearAndMouth: return "yearAndMouth".localized
        case .dateForTitle: return "dateForTitle".localized
        case .dateForChart: return "yyyy.MM.dd."
        case .timeForAccessibility: return "timeForAccessibility".localized
        }
    }
}
