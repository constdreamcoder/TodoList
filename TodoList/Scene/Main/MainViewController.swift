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
    
    let listImageNameList: [String] = ["14.square", "calendar", "tray.fill", "flag.fill", "checkmark"]
    let listTitleList: [String] = ["오늘", "예정", "전체", "깃발 표시", "완료됨"]
    let listBackgroundColor: [UIColor] = [.systemBlue, .systemPink, .lightGray, .systemYellow, .gray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOtherSettings()
        configureUserEvents()
    }
}

extension MainViewController {
    @objc func rightBarButtonItemTapped() {
        print(#function)
    }
    
    @objc func createTodoButtonTapped() {
        print(#function)
        
        let addNewTodoVC = AddTodoViewController()
        let navVC = UINavigationController(rootViewController: addNewTodoVC)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func createListButtonTapped() {
        print(#function)
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
            bottomTabView
        ].forEach { view.addSubview($0) }
        
        todoCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bottomTabView.snp.makeConstraints {
            $0.top.equalTo(todoCollectionView.snp.bottom)
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
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 3)
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
        return listImageNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.listImageContainerView.backgroundColor = listBackgroundColor[indexPath.item]
        cell.listImageView.image = UIImage(systemName: listImageNameList[indexPath.item])
        cell.titleLabel.text = listTitleList[indexPath.item]
        
        
        return cell
    }
}
