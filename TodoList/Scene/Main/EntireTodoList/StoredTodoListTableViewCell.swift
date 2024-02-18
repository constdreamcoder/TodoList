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
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Top StackView
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = topStackViewBaseSpacing
        [
            priorityLabel,
            titleLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let priorityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = contentStackViewBaseSpacing
        [
            memoLabel,
            bottomStackView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    // MARK: - Middle
    let memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Bottom StackView
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = bottomStackViewBaseSpacing
        [
            dueDateLabel,
            tagLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemCyan
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    private let topStackViewBaseSpacing = 4.0
    private let contentStackViewBaseSpacing = 8.0
    private let bottomStackViewBaseSpacing = 4.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetConstraints(_ todo: TodoModel) {
        if todo.priority == nil {
            topStackView.spacing = 0.0
        } else {
            topStackView.spacing = 4.0
        }
        
        if todo.memo == nil {
            contentStackView.spacing = 0.0
        } else {
            contentStackView.spacing = 8.0
        }
        
        if todo.dueDate?.getConvertedselectedDate == nil {
            bottomStackView.spacing = 0.0
        } else {
            bottomStackView.spacing = 4.0
        }
    }
}

extension StoredTodoListTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            completeButton,
            topStackView,
            contentStackView
        ].forEach { contentView.addSubview($0) }
        
        completeButton.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(8.0)
        }
        
        topStackView.snp.makeConstraints {
            $0.centerY.equalTo(completeButton)
            $0.leading.equalTo(completeButton.snp.trailing).offset(16.0)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(8.0)
            $0.leading.equalTo(topStackView)
            $0.trailing.bottom.equalToSuperview().inset(16.0)
        }
        
        memoLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionStyle = .none
    }
}

