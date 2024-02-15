//
//  RealmManager.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func addTodo(title: String, memo: String?, tag: String, priority: String, dueDate: Date) {
        let todo = TodoModel(title: title, memo: memo, tag: tag, priority: priority, dueDate: dueDate, regDate: Date())
        try! realm.write {
            realm.add(todo)
            print(realm.configuration.fileURL!)
        }
    }
    
    func readTodoList() -> Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
}
