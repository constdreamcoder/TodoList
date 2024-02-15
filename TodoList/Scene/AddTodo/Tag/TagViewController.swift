//
//  TagViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class TagViewController: UIViewController {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "추가할 태그명을 입력해주세요."
        textField.borderStyle = .none
        textField.textColor = .white
        textField.tintColor = .white
        textField.backgroundColor = .lightGray
        textField.font = .systemFont(ofSize: 18.0)
        return textField
    }()

    var navigationItemTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if textField.text != "" {
            guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            NotificationCenter.default.post(name: NSNotification.Name("SendNewTag"), object: nil, userInfo: ["tag": text])
        }
    }
}

extension TagViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = navigationItemTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureConstraints() {
        view.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
