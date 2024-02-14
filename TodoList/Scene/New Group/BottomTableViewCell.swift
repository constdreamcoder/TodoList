//
//  BottomTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class BottomTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마감일"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "마감일"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
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

extension BottomTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            titleLabel,
            subTitleLabel,
            chevronImageView
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(16.0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8.0)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .darkGray
    }
}
