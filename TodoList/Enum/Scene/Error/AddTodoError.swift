//
//  AddTodoError.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/17/24.
//

import Foundation

enum AddTodoError: Error {
    case emptyTitle
    case emptyTag
    
    var errorMessage: String {
        switch self {
        case .emptyTitle:
            return "제목이 비어있습니다."
        case .emptyTag:
            return "태그가 비어있습니다."
        }
    }
}
