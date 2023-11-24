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
    case detailedDate
    case dateForAccessibility
    case basicDate
    
    var description: String {
        switch self {
        case .timeWithoutSecond: return "timeWithoutSecond".localized
        case .yearAndMouth: return "yearAndMouth".localized
        case .dateForTitle: return "dateForTitle".localized
        case .dateForChart: return "dateForChart".localized
        case .timeForAccessibility: return "timeForAccessibility".localized
        case .detailedDate: return "detailedDate".localized
        case .dateForAccessibility: return "dateForAccessibility".localized
        case .basicDate: return "basicDate".localized
        }
    }
}
