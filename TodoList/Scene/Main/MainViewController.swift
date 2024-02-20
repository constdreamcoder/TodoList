//
//  MainViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    lazy var todoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private let myListTitle: UILabel = {
        let label = UILabel()
        label.text = "나의 목록"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32.0)
        return label
    }()
    
    lazy var myListTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    lazy var bottomTabView: UIView = {
        let view = UIView()
        [createTodoButton, createListButton].forEach { view.addSubview($0) }
        return view
    }()
    
    let createTodoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("새로운 할 일", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: -16, bottom: 0, right: 0)
        return button
    }()
    
    let createListButton: UIButton = {
        let button = UIButton()
        button.setTitle("목록 추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let titles: [MainCollectionViewTitleEnum] = MainCollectionViewTitleEnum.allCases
    
    private let todoCollectionViewSpacing: CGFloat = 16
    private lazy var todoCollectionViewItemSize = UIScreen.main.bounds.width - (todoCollectionViewSpacing * 3)
    
    private var todoList: [TodoModel] = []
    private var completedTodoList: [TodoModel] = []
    private var todayTodoList: [TodoModel] = []
    private var scheduledTodoList: [TodoModel] = []
    
    private var myListTitleList: [ListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)

        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOtherSettings()
        configureUserEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshTodoCollectionView()
        
        myListTitleList = RealmManager.shared.readListTitleList().map { $0 }
        
        myListTableView.reloadData()
        
        isCreateTodoButtonAvailable()
    }
    
    private func isCreateTodoButtonAvailable() {
        if myListTitleList.count > 0 {
            createTodoButton.isEnabled = true
        } else {
            createTodoButton.isEnabled = false
        }
    }
    
    private func refreshTodoCollectionView() {
        todoList = RealmManager.shared.readTodoList().map { $0 }
        completedTodoList = RealmManager.shared.filteringByCompleted.map { $0 }
        todayTodoList = RealmManager.shared.filteringByToday.map { $0 }
        scheduledTodoList = RealmManager.shared.filteringByScheduled.map { $0 }
        
        todoCollectionView.reloadData()
    }
}

extension MainViewController {
    @objc func rightBarButtonItemTapped() {
        print(#function)
    }
    
    @objc func createTodoButtonTapped() {
        print(#function)
                
        let addNewTodoVC = AddTodoViewController()
        addNewTodoVC.transferNewlyAddedTodo = { newTodo in
            self.todoList.append(newTodo)
            if let dueDate = newTodo.dueDate {
                if Calendar.current.isDateInToday(dueDate) {
                    self.todayTodoList.append(newTodo)
                } else if dueDate.compare(Date()) == .orderedDescending {
                    self.scheduledTodoList.append(newTodo)
                }
            }
            self.todoCollectionView.reloadData()
            self.myListTableView.reloadData()
        }
        let navVC = UINavigationController(rootViewController: addNewTodoVC)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func createListButtonTapped() {
        print(#function)
        
        let addListVC = AddListViewController()
        addListVC.transferNewList = { newList in
            self.myListTitleList.append(newList)
            self.myListTableView.reloadData()
            self.isCreateTodoButtonAvailable()
        }
        let navVC = UINavigationController(rootViewController: addListVC)
        present(navVC, animated: true)
    }
}

extension MainViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGray]
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGray]
        }
    }
    
    func configureConstraints() {
        [
            todoCollectionView,
            myListTitle,
            myListTableView,
            bottomTabView
        ].forEach { view.addSubview($0) }
        
        let itemHeight = (todoCollectionViewItemSize / 2) * 0.5
        let tableHeight = itemHeight * 3 + todoCollectionViewSpacing * 4
        todoCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(tableHeight)
        }
        
        myListTitle.snp.makeConstraints {
            $0.top.equalTo(todoCollectionView.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        myListTableView.snp.makeConstraints {
            $0.top.equalTo(myListTitle.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomTabView.snp.top)
        }
        
        bottomTabView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        createTodoButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
        }
        
        createListButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        todoCollectionView.backgroundColor = .clear
    }
    
    func configureOtherSettings() {
        configureCollectionView()
    }
    
    func configureUserEvents() {
        createTodoButton.addTarget(self, action: #selector(createTodoButtonTapped), for: .touchUpInside)
        createListButton.addTarget(self, action: #selector(createListButtonTapped), for: .touchUpInside)
    }
}

extension MainViewController: UICollectionViewConfigurationProtocol {
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let spacing = todoCollectionViewSpacing
        let itemSize = todoCollectionViewItemSize
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize / 2, height: (itemSize / 2) * 0.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
    
    func configureCollectionView() {
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        
        todoCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let entireTodoListVC = EntireTodoListViewController()
            navigationController?.pushViewController(entireTodoListVC, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }
        
        let title = titles[indexPath.item]
        
        cell.listImageContainerView.backgroundColor = title.listBackgroundColor
        cell.listImageView.image = UIImage(systemName: title.listImageName)
        cell.titleLabel.text = title.rawValue
        if title == .all {
            cell.numberLabel.text = "\(todoList.count)"
        } else if title == .completed {
            cell.numberLabel.text = "\(completedTodoList.count)"
        } else if title == .today {
            cell.numberLabel.text = "\(todayTodoList.count)"
        } else if title == .scheduled {
            cell.numberLabel.text = "\(scheduledTodoList.count)"
        } else {
            cell.numberLabel.text = "0"
        }
        
        return cell
    }
}


extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            let list = self.myListTitleList[indexPath.row]

            if let error = RealmManager.shared.deleteList(list) {
                print(error)
            } else {
                self.myListTitleList.remove(at: indexPath.row)
                tableView.reloadData()
                
                self.isCreateTodoButtonAvailable()
                
                self.refreshTodoCollectionView()
                completionHandler(true)
            }
        }
                
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        let list = myListTitleList[indexPath.row]
        cell.listTitleLabel.text = list.title
        cell.todoNumberLabel.text = "\(list.todoList.count)"
        
        return cell
    }
}
