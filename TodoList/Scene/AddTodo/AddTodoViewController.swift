//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit
import Toast

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
    private let titleList: [String] = ["마감일", "태그", "우선 순위", "이미지 추가", "목록"]
    
    var todoTitle: String = ""
    var memo: String?
    var selectedDate: Date?
    var newTag: String = ""
    var newPrioirty: String?
    var newlySelectedImage: UIImage?
    var selectedList = RealmManager.shared.readListTitleList().map { $0 }.first
    
    var transferNewlyAddedTodo: ((TodoModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTag), name: NSNotification.Name("SendNewTag"), object: nil)
    }
    
    private func checkError() throws -> Bool {
        guard !todoTitle.isEmpty else {
            throw AddTodoError.emptyTitle
        }
        
        guard !newTag.isEmpty else {
            throw AddTodoError.emptyTag
        }
    
        return true
    }
    
    private func showErrorMessage(_ error: Error) {
        switch error {
        case AddTodoError.emptyTitle:
            view.makeToast(AddTodoError.emptyTitle.errorMessage)
        case AddTodoError.emptyTag:
            view.makeToast(AddTodoError.emptyTag.errorMessage)
        default: break
        }
    }
}

extension AddTodoViewController {
    @objc func leftBarButtonItemTapped() {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rightBarButtonItemTapped() {
        print(#function)
    
        do {
            if try checkError() {
                guard 
                    let transferNewlyAddedTodo = transferNewlyAddedTodo,
                    let selectedList = selectedList
                else { return }
                
                let newTodo = RealmManager.shared.addTodo(title: todoTitle, memo: memo, tag: newTag, priority: newPrioirty, dueDate: selectedDate, list: selectedList)
                transferNewlyAddedTodo(newTodo!)
                
                if let newlySelectedImage = newlySelectedImage {
                    saveImageToDocument(image: newlySelectedImage, filename: "\(newTodo!.id)")
                }
                
                dismiss(animated: true)
            }
        } catch {
            showErrorMessage(error)
        }
    }
    
    @objc func addNewTag(_ notification: NSNotification) {
        if let newTag = notification.userInfo?["tag"] as? String {
            print(newTag)
            self.newTag = newTag
            let weight = placeholderList.count + 1
            topTableView.reloadRows(at: [IndexPath(row: 1 + weight, section: 0)], with: .automatic)
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
        if indexPath.row == 2 {
            return 16.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weight = placeholderList.count + 1
        
        if indexPath.row == (0 + weight) {
            let dateVC = DateViewController()
            dateVC.navigationItemTitle = titleList[indexPath.row - weight]
            dateVC.transferDate = { selectedDate in
                self.selectedDate = selectedDate
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            navigationController?.pushViewController(dateVC, animated: true)
        } else if indexPath.row == (1 + weight) {
            let tagVC = TagViewController()
            tagVC.navigationItemTitle = titleList[indexPath.row - weight]
            navigationController?.pushViewController(tagVC, animated: true)
        } else if indexPath.row == (2 + weight) {
            let priorityVC = PriorityViewController()
            priorityVC.navigationItemTitle = titleList[indexPath.row - weight]
            priorityVC.delegate = self
            navigationController?.pushViewController(priorityVC, animated: true)
        } else if indexPath.row == (3 + weight) {
            let addImageVC = AddImageViewController()
            addImageVC.navigationItemTitle = titleList[indexPath.row - weight]
            addImageVC.delegate = self
            navigationController?.pushViewController(addImageVC, animated: true)
        } else if indexPath.row == (4 + weight) {
            let selectListVC = SelectListViewController()
            selectListVC.navigationItemTitle = titleList[indexPath.row - weight]
            selectListVC.transferSelectedList = { selectedList in
                self.selectedList = selectedList
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            navigationController?.pushViewController(selectListVC, animated: true)
        }
    }
}

extension AddTodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (placeholderList.count + titleList.count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as? TopTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.placeholder = placeholderList[indexPath.row]
            if indexPath.row == 0 {
                cell.titleOrMemo = .title
            } else if indexPath.row == 1 {
                cell.titleOrMemo = .memo
            }
            
            return cell
        } else if indexPath.row == 2 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as? BottomTableViewCell else { return UITableViewCell() }
            
            let weight = placeholderList.count + 1
            
            cell.titleLabel.text = titleList[indexPath.row - weight]
            if indexPath.row == 0 + weight {
                cell.cellType = .dueDate
                cell.subTitleLabel.text = selectedDate?.getConvertedselectedDate
            } else if indexPath.row == 1 + weight {
                cell.cellType = .tag
                cell.subTitleLabel.text = newTag
            } else if indexPath.row == 2 + weight {
                cell.cellType = .priority
                cell.subTitleLabel.text = newPrioirty
            } else if indexPath.row == 3 + weight {
                cell.cellType = .addImage
                cell.selectedImageView.image = newlySelectedImage
            } else if indexPath.row == 4 + weight {
                cell.cellType = .list
                cell.subTitleLabel.text = selectedList?.title
            }

            return cell
        }
    }
}

extension AddTodoViewController: TableViewCellDelegate {
    func transferText(text: String, titleOrMemo: TitleOrMemo) {
        switch titleOrMemo {
        case .title:
            self.todoTitle = text
        case .memo:
            self.memo = text
        case .none: break;
        }
    }
    
    func updateTextViewHeight(_ cell: TopTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = topTableView.sizeThatFits(
            CGSize(
                width: size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            topTableView.beginUpdates()
            topTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension AddTodoViewController: PriorityDelegate {
    func transferNewPriority(priority: String) {
        self.newPrioirty = priority
        let weight = placeholderList.count + 1
        topTableView.reloadRows(at: [IndexPath(row: weight + 2, section: 0)], with: .automatic)
    }
}

extension AddTodoViewController: AddImageDelegate {
    func transferSelectedImage(_ image: UIImage?) {
        self.newlySelectedImage = image
        let weight = placeholderList.count + 1
        topTableView.reloadRows(at: [IndexPath(row: weight + 3, section: 0)], with: .automatic)
    }
}
