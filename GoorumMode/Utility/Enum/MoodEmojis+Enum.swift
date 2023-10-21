//
//  MoodEmojis+Enum.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/29.
//

import UIKit

enum MoodEmojis: String, CaseIterable {
    case smiling = "0_Basic_Smiling"
    case neutral = "1_Basic_Neutral"
    case surprised = "2_Basic_Surprised"
    case happy = "3_Basic_Happy"
    case tired = "4_Basic_Tired"
    case angry = "5_Basic_Angry"
    case lol = "6_Basic_LOL"
    case embarrassed = "7_Basic_Embarrassed"
    case sad = "8_Basic_Sad"
    case smirking = "9_Basic_Smirking"
    case lovely = "10_Basic_Lovely"
    case passionate = "11_Basic_Passionate"
    
    static let placeholder = "Mood_Placeholder"
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var accessLabel: String {
        switch self {
        case .smiling: return "smiling".localized
        case .neutral: return "neutral".localized
        case .surprised: return "surprised".localized
        case .happy: return "happy".localized
        case .tired: return "tired".localized
        case .angry: return "angry".localized
        case .lol: return "lol".localized
        case .embarrassed: return "embarrassed".localized
        case .sad: return "sad".localized
        case .smirking: return "smirking".localized
        case .lovely: return "lovely".localized
        case .passionate: return "passionate".localized
        }
    }
}
