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
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    var sortingMenuItems: [UIAction] {
        return [
            UIAction(title: "마감일 순으로 보기", handler: { (_) in
                print("마감일 순으로 보기")
                self.sortedORFilteredTodoList = RealmManager.shared.readTodoList().sorted(byKeyPath: "dueDate", ascending: true).map { $0 }
                self.storedTodoListTableView.reloadData()
            }),
            UIAction(title: "제목 순으로 보기", handler: { (_) in
                print("제목 순으로 보기")
                self.sortedORFilteredTodoList = RealmManager.shared.readTodoList().sorted(byKeyPath: "title", ascending: true).map { $0 }
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
                self.sortedORFilteredTodoList = RealmManager.shared.readTodoList().where { $0.priority == "낮음" }.map { $0 }
                self.storedTodoListTableView.reloadData()
                print(self.storedTodoList)
            }),
        ]
    }
    
    var filteringMenu: UIMenu {
        return UIMenu(title: "필터 메뉴", image: nil, identifier: nil, options: [], children: filteringMenuItems)
    }
    
    let storedTodoList: [TodoModel] = RealmManager.shared.readTodoList().map{ $0 }
    
    var sortedORFilteredTodoList: [TodoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOtherSettings()
    }
    
}

extension EntireTodoListViewController {
    
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
        sortedORFilteredTodoList = storedTodoList
    }
    
    func configureUserEvents() {
        
    }
}

extension EntireTodoListViewController: UITableViewDelegate {
    
}

extension EntireTodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedORFilteredTodoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoredTodoListTableViewCell.identifier, for: indexPath) as? StoredTodoListTableViewCell else { return UITableViewCell() }
        
        let todo = sortedORFilteredTodoList[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.tagLabel.text = "#\(todo.tag)"
        return cell
    }
}
