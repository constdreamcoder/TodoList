//
//  UICollectionViewConfigurationProtocol.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import UIKit

protocol UICollectionViewConfigurationProtocol: AnyObject {
    func configureCollectionViewLayout() -> UICollectionViewLayout
    func configureCollectionView()
}
