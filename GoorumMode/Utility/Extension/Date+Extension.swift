//
//  Date+Extension.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/30.
//

import UIKit

extension Date {
    
    func toString(of type: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = type.description
        return formatter.string(from: self)
    }
}

extension String {
    
    func toDate(to type: DateFormatType) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = type.description
        return formatter.date(from: self)
    }
    
}
