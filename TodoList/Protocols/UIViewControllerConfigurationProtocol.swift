//
//  UIViewControllerConfigurationProtocol.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import Foundation

protocol UIViewControllerConfigurationProtocol: AnyObject {
    func configureNavigationBar()
    func configureConstraints()
    func configureUI()
    func configureOtherSettings()
    func configureUserEvents()
}
