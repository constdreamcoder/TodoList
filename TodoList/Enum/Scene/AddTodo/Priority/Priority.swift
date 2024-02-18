//
//  Priority.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/17/24.
//

import Foundation

enum Priority: String, CaseIterable {
    case low = "낮음"
    case medium = "중간"
    case high = "높음"
    
    static func getExclamationMarksDependingOnPriority(_ priorityString: String?) -> String {
        switch priorityString {
        case "낮음": return "!"
        case "중간": return "!!"
        case "높음": return "!!!"
        default: return ""
        }
    }
}
