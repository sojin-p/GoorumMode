//
//  MoodRepository.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/02.
//

import Foundation
import RealmSwift

enum DateRange: Int {
    case daliy
    case weekly
    case monthly
}

class MoodRepository {
    
    private let realm = try! Realm()
    private lazy var basicFetch = realm.objects(Mood.self).sorted(byKeyPath: "date", ascending: false)
    
    func checkFileURL() {
        print("파일 경로: \(realm.configuration.fileURL!)")
    }
    
    func countMoods(moods: [Mood]) -> [String: Int] {
        var moodCounts: [String: Int] = [:]
        for mood in moods {
            let mood = mood.mood
            if moodCounts.keys.contains(mood) {
                moodCounts[mood] = (moodCounts[mood] ?? 0) + 1
            } else {
                moodCounts[mood] = 1
            }
        }
        
        return moodCounts
    }
    
    func fetch(dateRange: DateRange, selectedDate: Date = Date(), completionHandler: ((Date, Date) -> Void)? = nil) -> [Mood] {
        let calendar = Calendar.current
        var selectedDate = calendar.startOfDay(for: selectedDate)
        var startDate: Date = selectedDate
        var endDate: Date
        
        switch dateRange {
        case .daliy:
            endDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
            
        case .weekly:
            startDate = calendar.date(byAdding: .day, value: -7, to: selectedDate) ?? Date()
            endDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
            
        case .monthly:
            startDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
            endDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
        }
        completionHandler?(startDate, endDate)
        let moodsForMonth = realm.objects(Mood.self).filter("date >= %@ AND date < %@", startDate, endDate).sorted(byKeyPath: "date", ascending: false)
        return moodsForMonth.toArray()
    }
    
    func fetchMonth(year: Int, month: Int) -> Results<Mood> {
        let components = DateComponents(year: year, month: month)
        let startDate = Calendar.current.date(from: components)!
        guard let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else { return basicFetch }
        
        let moodsForMonth = realm.objects(Mood.self).filter("date >= %@ AND date < %@", startDate, endDate)
        return moodsForMonth
    }
    
    func createItem(_ item: Mood) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
        
    }
    
    func updateItem(_ item: Mood) {
        
        do {
            try realm.write {
                realm.create(Mood.self, value: ["_id": item._id, "mood": item.mood, "date": item.date, "onelineText": item.onelineText, "detailText": item.detailText, "image": item.image], update: .modified)
            }
        } catch {
            print("수정 오류 \(error)")
        }
    }
    
    func deleteItem(_ id: ObjectId) {
        
        let item = realm.object(ofType: Mood.self, forPrimaryKey: id)
        
        guard let item else { return }
        
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("삭제 오류 \(error)")
        }
    }
    
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
