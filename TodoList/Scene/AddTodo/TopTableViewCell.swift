//
//  TopTableViewCell.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

protocol TableViewCellDelegate: AnyObject {
    func transferText(text: String, titleOrMemo: TitleOrMemo)
    func updateTextViewHeight(_ cell: TopTableViewCell,_ textView:UITextView)
}

final class TopTableViewCell: UITableViewCell {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()
    
    weak var delegate: TableViewCellDelegate?
    
    var placeholder: String = "" {
        willSet {
            textView.text = newValue
        }
    }
    
    var titleOrMemo: TitleOrMemo = .none {
        didSet {
            updateCellCornerRadius()
            addMemoHeightConstraints()
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
    
    private func updateCellCornerRadius() {
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        if titleOrMemo == .title {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if titleOrMemo == .memo {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    private func addMemoHeightConstraints() {
        if titleOrMemo == .memo {
            textView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(100.0)
            }
        }
    }
}

extension TopTableViewCell: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureTableViewCellUI() {
        backgroundColor = .darkGray
        selectionStyle = .none
    }
}

extension TopTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            guard let text = textView.text else { return }
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            delegate.transferText(text: trimmedText, titleOrMemo: self.titleOrMemo)
            delegate.updateTextViewHeight(self, textView)
        }
    }
}
