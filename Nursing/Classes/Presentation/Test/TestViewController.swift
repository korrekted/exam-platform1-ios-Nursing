//
//  TestViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class TestViewController: UIViewController {
    lazy var mainView = TestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((Int) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .bind(to: viewModel.selectedAnswers)
            .disposed(by: disposeBag)
        
        mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .compactMap { $0 == .submit ? () : nil }
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .map { $0.questionsCount == 1 }
            .distinctUntilChanged()
            .drive(mainView.progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(mainView) { view, element in
                view.progressView.setProgress(Float(element.index) / Float(element.questionsCount), animated: true)
                let isNeedOffset = element.isMultiple || element.questionsCount == 1
                view.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: isNeedOffset ? 150 : 0, right: 0)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                viewModel.isEndOfTest,
                mainView.nextButton.rx.tap.asDriver().map { _ in true }
            )
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.userTestId
            .bind(to: Binder(self) {
                $0.didTapSubmit?($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .drive(Binder(mainView) {
                $0.setupBottomButton(for: $1)
            })
            .disposed(by: disposeBag)
        
        
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType) -> TestViewController {
        let controller = TestViewController()
        if #available(iOS 13.0, *) {
            controller.isModalInPresentation = true
        }
        controller.viewModel.testType.accept(testType)
        return controller
    }
}
