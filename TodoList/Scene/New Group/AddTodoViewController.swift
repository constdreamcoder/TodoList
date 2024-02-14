//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class AddTodoViewController: UIViewController {
    
    lazy var addTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.identifier)
        tableView.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let placeholderList: [String] = ["제목", "메모"]
    private let titleList: [String] = ["마감일", "태그", "우선 순위", "이미지 추가"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
}

extension AddTodoViewController {
    @objc func leftBarButtonItemTapped() {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rightBarButtonItemTapped() {
        print(#function)
    }
}

extension AddTodoViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "새로운 할일"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
    }
    
    func configureConstraints() {
        [
            addTableView
        ].forEach { view.addSubview($0) }
        
        addTableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureOtherSettings() {
        
    }
    
    func configureUserEvents() {
        
    }
}

extension AddTodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AddTodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (placeholderList.count + titleList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as? TopTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.placeholder = placeholderList[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as? BottomTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = titleList[indexPath.row - placeholderList.count]
            return cell
        }
    }
}

extension AddTodoViewController: TableViewCellDelegate {
    func updateTextViewHeight(_ cell: TopTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = addTableView.sizeThatFits(
            CGSize(
                width: size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        print(newSize)
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            addTableView.beginUpdates()
            addTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}
