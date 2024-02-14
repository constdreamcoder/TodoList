//
//  UICollectionViewCell+Extension.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import UIKit

extension UICollectionViewCell: IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
