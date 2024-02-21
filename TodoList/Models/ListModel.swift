//
//  ListModel.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import Foundation
import RealmSwift

final class ListModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var regDate: Date
    @Persisted var renamedNewColumn2: String
    @Persisted var newTitle: String
    
    @Persisted var todoList: List<TodoModel>
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
        self.regDate = Date()
    }
}
