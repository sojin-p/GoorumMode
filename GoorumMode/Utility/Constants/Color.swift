//
//  Color.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/25.
//

import UIKit

extension Constants {
    
    enum Color {
        
        enum Text {
            static let basicTitle = UIColor(resource: .basicTitle)
            static let basicSubTitle = UIColor(resource: .basicSubTitle)
            static let basicPlaceholder = UIColor(resource: .basicPlaceholder)
        }
        
        enum Background {
            static let basic = UIColor(resource: .basicBackground)
            static let basicIcon = UIColor(resource: .basicIconBackground)
            static let white = UIColor(resource: .basicWhite)
            static let calendar = UIColor(resource: .basicCalendarBackground)
            static let progressTrack = UIColor(resource: .basicProgressBackground)
            static let chartETC = UIColor(resource: .basicChartETC)
        }
        
        enum iconTint {
            static let basicWhite = UIColor(resource: .basicWhite)
            static let basicBlack = UIColor(resource: .basicTitle)
            static let unselected = UIColor(resource: .basicSubTitle)
        }
        
    }
    
}
