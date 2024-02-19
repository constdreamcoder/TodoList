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
    
    var filteringByToday: Results<TodoModel> {
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@", start as NSDate, end as NSDate)
        return readTodoList().filter(predicate)
    }
    
    var filteringByScheduled: Results<TodoModel> {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? Date()
        
        let predicate = NSPredicate(format: "dueDate >= %@", tomorrow as NSDate)
        return readTodoList().filter(predicate)
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
