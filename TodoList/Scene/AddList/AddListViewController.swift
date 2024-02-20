//
//  AddListViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

final class AddListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.register(AddListTitleTableViewCell.self, forCellReuseIdentifier: AddListTitleTableViewCell.identifier)
        
        return tableView
    }()
    
    var transferNewList: ((ListModel) -> Void)?
    
    private var newListTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }

}

extension AddListViewController {
    @objc func leftBarButtonItemTapped() {
        print("취소")
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonItemTapped() {
        print("완료")
        
        let newList = ListModel(title: newListTitle)
                
        let error = RealmManager.shared.addList(newList: newList)
        
        if error == nil {
            guard let transferNewList = transferNewList else { return }
            transferNewList(newList)
            
            dismiss(animated: true)
        } else {
            // alert 생성
            print("리스트 추가를 실패하였습니다.")
        }
    }
}

extension AddListViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = "새로운 목록"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        configureTableViewCellUI()
    }
    
    func configureOtherSettings() {
        
    }
    
    func configureUserEvents() {
        
    }
}

extension AddListViewController: UITableViewCellConfigurationProtocol {
    func configureTableViewCellConstraints() {
        
    }
    
    func configureTableViewCellUI() {
        tableView.backgroundColor = .clear
    }
}

extension AddListViewController: UITableViewDelegate {
    
}

extension AddListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddListTableViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row  == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddListTitleTableViewCell.identifier, for: indexPath) as? AddListTitleTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
}

extension AddListViewController: AddListTitleTableViewCellDelegate {
    func transferTextInput(input text: String?) {
        guard let text = text else { return }
        
        if text != "" && text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.newListTitle = text
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
                                    
