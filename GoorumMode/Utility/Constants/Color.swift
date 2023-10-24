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
            static let basicTitle = UIColor(named: "Basic_Title")
            static let basicSubTitle = UIColor(named: "Basic_SubTitle")
            static let basicPlaceholder = UIColor(named: "Basic_Placeholder")
        }
        
        enum Background {
            static let basic = UIColor(named: "Basic_Background")
            static let basicIcon = UIColor(named: "Basic_IconBackground")
            static let white = UIColor(named: "Basic_White")
            static let calendar = UIColor(named: "Basic_CalendarBackground")
            
            static let smiling = UIColor(named: "Smiling_Theme")
            
            static let Neutral = UIColor(named: "Neutral_Theme")
        }
        
        enum iconTint {
            static let basicWhite = UIColor(named: "Basic_White")
            static let basicBlack = UIColor(named: "Basic_Title")
            static let unselected = UIColor(named: "Basic_SubTitle")
        }
        
    }
    
}
