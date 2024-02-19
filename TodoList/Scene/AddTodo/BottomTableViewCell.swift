//
//  BottomTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class BottomTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        [
            titleLabel,
            chevronImageView,
        ].forEach { view.addSubview($0) }
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마감일"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var cellType: BottomTableViewCellType = .none {
        didSet {
            updateTableViewCellConstraints()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTableViewCellConstraints() {
        if cellType == .addImage {
            containerView.addSubview(selectedImageView)
            
            selectedImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(20.0)
                $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8.0)
            }
        } else {
            containerView.addSubview(subTitleLabel)

            subTitleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8.0)
            }
        }
    }
}

extension BottomTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            containerView,
            dividerView
        ].forEach { contentView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(16.0)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.height.equalTo(16.0)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
}
