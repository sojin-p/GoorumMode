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
        case .yearAndMouth: return "yyyy년 M월"
        case .dateForTitle: return "M월 dd일 EEEE"
        case .dateForChart: return "yyyy.MM.dd."
        case .timeForAccessibility: return "a hh시 mm분"
        }
    }
}
