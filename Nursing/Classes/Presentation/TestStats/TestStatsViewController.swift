//
//  TestStatsViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TestStatsViewController: UIViewController {
    lazy var mainView = TestStatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestStatsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.elements.startWith([])
            .drive(Binder(mainView.tableView) {
                $0.setup(elements: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.testName
            .drive(mainView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedFilter
            .bind(to: viewModel.filterRelay)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestStatsViewController {
    static func make(userTestId: Int, testType: TestType) -> TestStatsViewController {
        let controller = TestStatsViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.userTestId.accept(userTestId)
        controller.viewModel.testType.accept(testType)
        return controller
    }
}
