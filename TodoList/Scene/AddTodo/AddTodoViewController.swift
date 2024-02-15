//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

protocol PriorityTransferDelegate: AnyObject {
    func transferNewPriority(priority: String)
}

final class AddTodoViewController: UIViewController {
    
    lazy var topTableView: UITableView = {
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
    
    var selectedDateString: String = ""
    var newTag: String = ""
    var newPrioirty: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTag), name: NSNotification.Name("SendNewTag"), object: nil)
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
    
    @objc func addNewTag(_ notification: NSNotification) {
        if let newTag = notification.userInfo?["tag"] as? String {
            print(newTag)
            self.newTag = newTag
            topTableView.reloadRows(at: [IndexPath(row: 1 + placeholderList.count, section: 0)], with: .automatic)
        }
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
            topTableView
        ].forEach { view.addSubview($0) }
        
        topTableView.snp.makeConstraints {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weightIndex = placeholderList.count
        
        if indexPath.row == (0 + weightIndex) {
            let dateVC = DateViewController()
            dateVC.navigationItemTitle = titleList[indexPath.row - weightIndex]
            dateVC.transferDate = { selectedDate in
                self.selectedDateString = selectedDate
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            navigationController?.pushViewController(dateVC, animated: true)
        } else if indexPath.row == (1 + weightIndex) {
            let tagVC = TagViewController()
            tagVC.navigationItemTitle = titleList[indexPath.row - weightIndex]
            navigationController?.pushViewController(tagVC, animated: true)
        } else if indexPath.row == (2 + weightIndex) {
            let priorityVC = PriorityViewController()
            priorityVC.navigationItemTitle = titleList[indexPath.row - weightIndex]
            priorityVC.delegate = self
            navigationController?.pushViewController(priorityVC, animated: true)
        }
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
            
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 8.0
                cell.layer.masksToBounds = true
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == 1 {
                cell.layer.cornerRadius = 8.0
                cell.layer.masksToBounds = true
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as? BottomTableViewCell else { return UITableViewCell() }
            
            let weight = placeholderList.count
            
            cell.titleLabel.text = titleList[indexPath.row - weight]
            if indexPath.row == 0 + weight {
                cell.subTitleLabel.text = selectedDateString
            } else if indexPath.row == 1 + weight {
                cell.subTitleLabel.text = newTag
            } else if indexPath.row == 2 + weight {
                cell.subTitleLabel.text = newPrioirty
            }
            
            return cell
        }
    }
}

extension AddTodoViewController: TableViewCellDelegate {
    func updateTextViewHeight(_ cell: TopTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = topTableView.sizeThatFits(
            CGSize(
                width: size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        print(newSize)
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            topTableView.beginUpdates()
            topTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension AddTodoViewController: PriorityTransferDelegate {
    func transferNewPriority(priority: String) {
        self.newPrioirty = priority
        topTableView.reloadRows(at: [IndexPath(row: placeholderList.count + 2, section: 0)], with: .automatic)
    }
}