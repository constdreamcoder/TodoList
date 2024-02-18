//
//  EntireTodoListViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit
import RealmSwift

final class EntireTodoListViewController: UIViewController {
    
    lazy var storedTodoListTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(StoredTodoListTableViewCell.self, forCellReuseIdentifier: StoredTodoListTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    var sortingMenuItems: [UIAction] {
        return [
            UIAction(title: "마감일 순으로 보기", handler: { (_) in
                print("마감일 순으로 보기")
                self.sortedOrFilteredTodoList = RealmManager.shared.sortingybyDueDateInAscendingOrder.map { $0 }
                self.storedTodoListTableView.reloadData()
            }),
            UIAction(title: "제목 순으로 보기", handler: { (_) in
                print("제목 순으로 보기")
                self.sortedOrFilteredTodoList = RealmManager.shared.sortingybyTitleInAscendingOrder.map { $0 }
                self.storedTodoListTableView.reloadData()
            }),
        ]
    }
    
    var sortingMenu: UIMenu {
        return UIMenu(title: "정렬 메뉴", image: nil, identifier: nil, options: [], children: sortingMenuItems)
    }
    
    var filteringMenuItems: [UIAction] {
        return [
            UIAction(title: "우선 순위 낮음만 보기", handler: { (_) in
                print("우선 순위 낮음만 보기")
                self.sortedOrFilteredTodoList = RealmManager.shared.filteringByLowPriority.map { $0 }
                self.storedTodoListTableView.reloadData()
            }),
        ]
    }
    
    var filteringMenu: UIMenu {
        return UIMenu(title: "필터 메뉴", image: nil, identifier: nil, options: [], children: filteringMenuItems)
    }
    
    let storedTodoList: [TodoModel] = RealmManager.shared.readTodoList().map{ $0 }
    
    var sortedOrFilteredTodoList: [TodoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOtherSettings()
    }
    
    private func updateCompleteButtonImage(_ completeButton: UIButton, completed: Bool) {
        if completed {
            completeButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        } else {
            completeButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
}

extension EntireTodoListViewController {
    @objc func completeButtonTapped(_ button: UIButton) {
        let todo = sortedOrFilteredTodoList[button.tag]
        
        if let error = RealmManager.shared.updateCompleted(todo) {
            print(error)
        } else {
            updateCompleteButtonImage(button, completed: todo.completed)
            storedTodoListTableView.reloadRows(at: [IndexPath(row: button.tag, section: 0)], with: .none)
        }
    }
}

extension EntireTodoListViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGray]
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGray]
        }
        
        let sortingButton = UIBarButtonItem(title: "정렬", menu: sortingMenu)
        let filteringButton = UIBarButtonItem(title: "필터", menu: filteringMenu)
        
        navigationItem.rightBarButtonItems = [sortingButton, filteringButton]
    }
    
    func configureConstraints() {
        view.addSubview(storedTodoListTableView)
        
        storedTodoListTableView.snp.makeConstraints{
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureOtherSettings() {
        sortedOrFilteredTodoList = storedTodoList
    }
    
    func configureUserEvents() {
        
    }
}

extension EntireTodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            let todo = self.sortedOrFilteredTodoList[indexPath.row]
            
            if let error = RealmManager.shared.delete(todo) {
                print(error)
            } else {
                self.sortedOrFilteredTodoList.remove(at: indexPath.row)
                tableView.reloadData()
                completionHandler(true)
            }
        }
                
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension EntireTodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedOrFilteredTodoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoredTodoListTableViewCell.identifier, for: indexPath) as? StoredTodoListTableViewCell else { return UITableViewCell() }
        
        let todo = sortedOrFilteredTodoList[indexPath.row]
        
        cell.resetConstraints(todo)
        
        cell.priorityLabel.text = Priority.getExclamationMarksDependingOnPriority(todo.priority)
        cell.titleLabel.text = todo.title
        cell.memoLabel.text = todo.memo
        cell.dueDateLabel.text = todo.dueDate?.getConvertedselectedDate
        cell.tagLabel.text = "#\(todo.tag)"
        
        cell.completeButton.tag = indexPath.row
        updateCompleteButtonImage(cell.completeButton, completed: todo.completed)
        cell.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return cell
    }
}
