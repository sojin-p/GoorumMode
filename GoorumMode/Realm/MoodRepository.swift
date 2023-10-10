//
//  MoodRepository.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/02.
//

import Foundation
import RealmSwift

class MoodRepository {
    
    static let shared = MoodRepository()
    private init() { }
    
    private let realm = try! Realm()
    private lazy var basicFetch = realm.objects(Mood.self).sorted(byKeyPath: "date", ascending: false)
    
    func checkFileURL() {
        print("파일 경로: \(realm.configuration.fileURL!)")
    }
    
    func fetchMonth(year: Int, month: Int) -> Results<Mood> {
        let components = DateComponents(year: year, month: month)
        let startDate = Calendar.current.date(from: components)!
        guard let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else { return basicFetch }
        
        let moodsForMonth = realm.objects(Mood.self).filter("date >= %@ AND date < %@", startDate, endDate)
        return moodsForMonth
    }
    
    func fetch(selectedDate: Date) -> [Mood] {
        let startDate = Calendar.current.startOfDay(for: selectedDate)
        guard let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) else { return basicFetch.toArray() }
        
        let data = realm.objects(Mood.self).filter("date >= %@ AND date < %@", startDate, endDate).sorted(byKeyPath: "date", ascending: false)
        return data.toArray()
    }
    
    func createItem(_ item: Mood) {
        
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
        
    }
    
    func updateItem(_ item: Mood) {
        
        do {
            try realm.write {
                realm.create(Mood.self, value: ["_id": item._id, "mood": item.mood, "date": item.date, "onelineText": item.onelineText, "detailText": item.detailText, "image": item.image], update: .modified)
                print("수정 성공")
            }
        } catch {
            print("???")
        }
    }
    
    func deleteItem(_ id: ObjectId) {
        
        let item = realm.object(ofType: Mood.self, forPrimaryKey: id)
        
        guard let item else { return }
        
        do {
            try realm.write {
                realm.delete(item)
                print("삭제 성공")
            }
        } catch {
            print("")
        }
    }
    
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
