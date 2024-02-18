//
//  Date+Extension.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/17/24.
//

import Foundation

extension Date {
    var getConvertedselectedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. dd"
        return dateFormatter.string(from: self) 
    }
}
