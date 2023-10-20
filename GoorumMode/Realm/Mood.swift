//
//  Mood.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/27.
//

import Foundation
import RealmSwift

final class Mood: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var mood: String
    @Persisted var date: Date
    @Persisted var onelineText: String?
    @Persisted var detailText: String?
    @Persisted var imageList: List<String> = List<String>()
    
    var images: [String] {
        get {
            return imageList.map { $0 }
        }
        set {
            imageList.removeAll()
            imageList.append(objectsIn: newValue)
        }
    }
    
    convenience init(mood: String, date: Date, onelineText: String?, detailText: String?, images: [String] = []) {
        self.init()
        self.mood = mood
        self.date = date
        self.onelineText = onelineText
        self.detailText = detailText
        self.images = images
    }
}
