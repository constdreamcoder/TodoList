//
//  SelectListViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/20/24.
//

import UIKit
import SnapKit

final class SelectListViewController: UIViewController {

    lazy var registeredListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RegisteredListTableViewCell.self, forCellReuseIdentifier: RegisteredListTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var navigationItemTitle: String = ""
    
    var transferSelectedList: ((ListModel) -> Void)?
    
    private let registeredListTitleList: [ListModel] = RealmManager.shared.readListTitleList().map { $0 }
    
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let transferSelectedList = transferSelectedList else { return }
        let selectedList = registeredListTitleList[selectedIndexPath.row]
        transferSelectedList(selectedList)
    }
   
}

extension SelectListViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = navigationItemTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureConstraints() {
        view.addSubview(registeredListTableView)
        
        registeredListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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

extension SelectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}

extension SelectListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredListTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegisteredListTableViewCell.identifier, for: indexPath) as? RegisteredListTableViewCell else { return UITableViewCell() }
        
        let list = registeredListTitleList[indexPath.row]
        cell.listTitleLabel.text = list.title
        
        if selectedIndexPath.row == indexPath.row {
            cell.checkImageView.isHidden = false
        } else {
            cell.checkImageView.isHidden = true
        }
        return cell
    }
}
