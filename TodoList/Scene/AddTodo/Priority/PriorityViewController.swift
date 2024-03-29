//
//  PriorityViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

protocol PriorityDelegate: AnyObject {
    func transferNewPriority(priority: String)
}

final class PriorityViewController: UIViewController {
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        for (index, priority) in Priority.allCases.enumerated() {
            segmentControl.insertSegment(withTitle: priority.rawValue, at: index, animated: true)
        }
        segmentControl.backgroundColor = .white
        return segmentControl
    }()

    var navigationItemTitle: String = ""
    
    var delegate: PriorityDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard 0..<segmentControl.numberOfSegments ~= segmentControl.selectedSegmentIndex,
            let selectedSegmentTitle = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) else { return }
        delegate?.transferNewPriority(priority: selectedSegmentTitle)
    }
}

extension PriorityViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = navigationItemTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureConstraints() {
        view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints {
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
