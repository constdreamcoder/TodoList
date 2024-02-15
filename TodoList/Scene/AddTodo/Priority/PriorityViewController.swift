//
//  PriorityViewController.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/15/24.
//

import UIKit
import SnapKit

final class PriorityViewController: UIViewController {
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "낮음", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "중간", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "높음", at: 2, animated: true)

        segmentControl.backgroundColor = .white
        return segmentControl
    }()

    var navigationItemTitle: String = ""
    
    var delegate: PriorityTransferDelegate?

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
