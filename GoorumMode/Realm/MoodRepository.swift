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
    
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
