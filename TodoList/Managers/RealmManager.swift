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

    var sortingybyDueDateInAscendingOrder: Results<TodoModel> {
        return readTodoList().sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    var sortingybyTitleInAscendingOrder: Results<TodoModel> {
        return readTodoList().sorted(byKeyPath: "title", ascending: true)
    }
    
    var filteringByLowPriority: Results<TodoModel> {
        return readTodoList().where { $0.priority == "낮음" }
    }
    
    var filteringByCompleted: Results<TodoModel> {
        return readTodoList().where { $0.completed }
    }
    
    private init() {}
    
    func addTodo(title: String, memo: String?, tag: String, priority: String?, dueDate: Date?) -> TodoModel? {
        let todo = TodoModel(title: title, memo: memo, tag: tag, priority: priority, dueDate: dueDate, regDate: Date())
        
        do {
            return try realm.write {
                realm.add(todo)
                print(realm.configuration.fileURL!)
                return todo
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func readTodoList() -> Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
    
    func updateCompleted(_ item: TodoModel) -> Error? {
        do {
            return try realm.write {
                item.completed.toggle()
                return nil
            }
        } catch {
            return error
        }
    }
    
    func delete(_ item: TodoModel) -> Error? {
        do {
            return try realm.write {
                realm.delete(item)
                return nil
            }
        } catch {
            return error
        }
    }
}
