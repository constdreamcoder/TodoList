//
//  TodoModel.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var tag: String
    @Persisted var priority: String
    @Persisted var dueDate: Date
    @Persisted var regDate: Date
    
    convenience init(title: String, memo: String? = nil, tag: String, priority: String, dueDate: Date, regDate: Date) {
        self.init()
        
        self.title = title
        self.memo = memo
        self.tag = tag
        self.priority = priority
        self.dueDate = dueDate
        self.regDate = regDate
    }
}
