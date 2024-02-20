//
//  RegisteredListTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

protocol RegisteredListTableViewCellDelegate: AnyObject {
    func transferSelectedList(list: ListModel)
}

final class RegisteredListTableViewCell: UITableViewCell {
    
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        imageView.isHidden = true
        return imageView
    }()
    
    var isThisListSelected: Bool = false
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegisteredListTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            listIconImageContainerView,
            listTitleLabel,
            checkImageView
        ].forEach { contentView.addSubview($0) }
        
        listIconImageContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(16.0)
            $0.size.equalTo(26.0)
        }
        
        listIconImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.center.equalToSuperview()
        }
        
        listTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(listIconImageContainerView.snp.trailing).offset(16.0)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
            $0.leading.equalTo(listTitleLabel.snp.trailing).offset(16.0)
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
