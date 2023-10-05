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
    
    func checkFileURL() {
        print("파일 경로: \(realm.configuration.fileURL!)")
    }
    
    func fetch() -> Results<Mood> {
        let data = realm.objects(Mood.self).sorted(byKeyPath: "date", ascending: false)
        return data
    }
    
    func fetchToArray() -> [Mood] {
        return fetch().toArray()
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
    
    func updateItem(id: ObjectId, mood: String, date: Date, onelineText: String?, detailText: String?, image: String?) {
        
        do {
            try realm.write {
                realm.create(Mood.self, value: ["_id": id, "mood": mood, "date": date, "onelineText": onelineText, "detailText": detailText, "image": image ], update: .modified)
                print("수정 성공")
            }
        } catch {
            print("???")
        }
    }
    
    func deleteItem(_ item: Mood) {
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
