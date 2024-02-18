//
//  TodoModel.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import Foundation
import RealmSwift

final class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var tag: String
    @Persisted var priority: String?
    @Persisted var dueDate: Date?
    @Persisted var regDate: Date
    @Persisted var completed: Bool
    
    convenience init(title: String, memo: String? = nil, tag: String, priority: String? = nil, dueDate: Date? = nil, regDate: Date) {
        self.init()
        
        self.title = title
        self.memo = memo
        self.tag = tag
        self.priority = priority
        self.dueDate = dueDate
        self.regDate = regDate
        self.completed = false
    }
}
