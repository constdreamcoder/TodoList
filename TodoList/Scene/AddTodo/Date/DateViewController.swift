//
//  DateViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class DateViewController: UIViewController {

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .lightGray
        datePicker.layer.cornerRadius = 16.0
        datePicker.clipsToBounds = true
        return datePicker
    }()
    
    var navigationItemTitle: String = ""
    
    var transferDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureUserEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let transferDate = transferDate else { return }
        transferDate(datePicker.date)
    }
}

extension DateViewController {
    
}

extension DateViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = navigationItemTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureConstraints() {
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.center.equalTo(view.safeAreaLayoutGuide)
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
