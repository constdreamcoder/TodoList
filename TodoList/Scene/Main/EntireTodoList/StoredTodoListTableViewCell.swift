//
//  StoredTodoListTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class StoredTodoListTableViewCell: UITableViewCell {

    let completeButton: UIButton = {
        let button = UIButton()
        // 완료 의미의 이미지: circle.inset.filled
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개발하기"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "#여가"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoredTodoListTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            completeButton,
            titleLabel,
            tagLabel
        ].forEach { contentView.addSubview($0) }
        
        completeButton.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.bottom.equalToSuperview().inset(8.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(completeButton.snp.trailing).offset(16.0)
        }
        
        tagLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8.0)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionStyle = .none
    }
}

