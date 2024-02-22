//
//  DateManager.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/11/23.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    var selectedDate: Observable<Date> = Observable(Date())

}
