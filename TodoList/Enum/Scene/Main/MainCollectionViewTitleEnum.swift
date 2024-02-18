//
//  MainCollectionViewTitleEnum.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/17/24.
//

import UIKit

enum MainCollectionViewTitleEnum: String, CaseIterable {
    case today = "오늘"
    case scheduled = "예정"
    case all = "전체"
    case flagged = "깃발 표시"
    case completed = "완료됨"
    
    var listImageName: String {
        switch self {
        case .today:
            return "14.square"
        case .scheduled:
            return "calendar"
        case .all:
            return "tray.fill"
        case .flagged:
            return "flag.fill"
        case .completed:
            return "checkmark"
        }
    }
    
    var listBackgroundColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .scheduled:
            return .systemPink
        case .all:
            return .lightGray
        case .flagged:
            return .systemYellow
        case .completed:
            return .gray
        }
    }
}
