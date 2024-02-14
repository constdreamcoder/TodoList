//
//  UITableViewCell+Extension.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit

extension UITableViewCell: IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
