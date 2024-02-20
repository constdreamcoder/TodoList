//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

final class ListTableViewCell: UITableViewCell {
    
    lazy var listIconImageContainerView: UIView = {
        let view = UIView()
        view.addSubview(listIconImageView)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    let listIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet")
        imageView.tintColor = .white
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let listTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let todoNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
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

extension ListTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            listIconImageContainerView,
            listTitleLabel,
            chevronImageView,
            todoNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        listIconImageContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(26.0)
            $0.top.bottom.leading.equalToSuperview().inset(16.0)
        }
        
        listIconImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.center.equalToSuperview()
        }
        
        // TODO: - 텍스트 수에 따른 cell 크기 변화 구현
        listTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(listIconImageContainerView)
            $0.leading.equalTo(listIconImageContainerView.snp.trailing).offset(16.0)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
            $0.size.equalTo(16.0)
        }
        
        todoNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(chevronImageView)
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8.0)
            $0.leading.greaterThanOrEqualTo(listTitleLabel.snp.trailing).offset(8.0)
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
    }
}
