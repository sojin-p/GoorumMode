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
        case .smiling: return "미소 짓는"
        case .neutral: return "무표정"
        case .surprised: return "놀란"
        case .happy: return "행복한"
        case .tired: return "피곤한"
        case .angry: return "화난"
        case .lol: return "매우 신난"
        case .embarrassed: return "당황스러운"
        case .sad: return "슬픈"
        case .smirking: return "능글맞은"
        case .lovely: return "사랑스러운"
        case .passionate: return "열정적인"
        }
    }
}
