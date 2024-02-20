//
//  AddListTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

protocol AddListTitleTableViewCellDelegate: AnyObject {
    func transferTextInput(input text: String?)
}

final class AddListTitleTableViewCell: UITableViewCell {
    
    // MARK: - cellContentView
    lazy var cellContentView: UIView = {
        let view = UIView()
        [
            iconImageViewContainerView,
            titleTextField
        ].forEach { view.addSubview($0) }
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - iconImageView
    lazy var iconImageViewContainerView: UIView = {
        let view = UIView()
        view.addSubview(iconImageView)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = iconContainerViewWidth / 2
        view.clipsToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let iconContainerViewWidth: CGFloat = 80.0
    
    // MARK: - titleTextField
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24.0),
            NSAttributedString.Key.foregroundColor : UIColor.darkGray
        ])
        textField.backgroundColor = .lightGray
        textField.tintColor = .white
        textField.font = .boldSystemFont(ofSize: 24.0)
        textField.textColor = .white
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .center
        textField.layer.cornerRadius = 12.0
        textField.delegate = self
        return textField
    }()
    
    private let placeholder = "목록 이름"
    
    // MARK: - SeparatorView
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var delegate: AddListTitleTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTableViewCellConstraints()
        configureTableViewCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AddListTitleTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        [
            cellContentView,
            separatorView
        ].forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        // MARK: - cellContentView
        cellContentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        iconImageViewContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(iconContainerViewWidth)
        }
        
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(iconContainerViewWidth - 30)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(iconImageViewContainerView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
            $0.height.equalTo(48)
        }
        
        // MARK: - SeparatorView
        separatorView.snp.makeConstraints {
            $0.top.equalTo(cellContentView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16.0)
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .clear
    }
}

extension AddListTitleTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.transferTextInput(input: textField.text)
    }
}

