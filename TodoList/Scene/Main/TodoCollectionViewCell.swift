//
//  TodoCollectionViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import UIKit
import SnapKit

final class TodoCollectionViewCell: UICollectionViewCell {
    
    lazy var listImageContainerView: UIView = {
        let view = UIView()
        view.addSubview(listImageView)
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    let listImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .white
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionViewCellConstraints()
        configureCollectionViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TodoCollectionViewCell: UICollectionViewCellConfigurationProtocol {
    func configureCollectionViewCellConstraints() {
        [
            listImageContainerView,
            titleLabel,
            numberLabel
        ].forEach { contentView.addSubview($0) }
        
        listImageContainerView.snp.makeConstraints {
            $0.size.equalTo(26.0)
            $0.top.leading.equalToSuperview().inset(16.0)
        }
        
        listImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalTo(listImageView)
            $0.top.greaterThanOrEqualTo(listImageView.snp.bottom).offset(8.0)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalTo(listImageView)
            $0.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func configureCollectionViewCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
}
