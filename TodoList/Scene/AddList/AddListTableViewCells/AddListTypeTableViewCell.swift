//
//  AddListTypeTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

final class AddListTypeTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddListTypeTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
    }
}
