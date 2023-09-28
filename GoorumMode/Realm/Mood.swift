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
    @Persisted var image: String?
    
    convenience init(mood: String, date: Date) {
        self.init()
        self.mood = mood
        self.date = date
    }
}
