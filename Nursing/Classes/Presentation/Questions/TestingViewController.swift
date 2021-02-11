//
//  TestingViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class TestingViewController: UIViewController {
    lazy var mainView = TestingView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestingViewModel()
    
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
        
        viewModel.question
            .drive(Binder(mainView) { view, element in
                view.progressView.setProgress(Float(element.index) / Float(element.questionsCount), animated: true)
                let isResult = element.elements.contains(where: {
                    guard case .result = $0 else { return false }
                    return true
                })
                view.continueButton.isHidden = isResult ? true : !element.isMultiple
                view.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: element.isMultiple ? 150 : 0, right: 0)
            })
            .disposed(by: disposeBag)
        
        mainView.continueButton.rx.tap
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                viewModel.showNextButton.map(!),
                mainView.nextButton.rx.tap.asDriver().map { _ in true }
            )
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(
                viewModel.showNextButton,
                viewModel.question.map { $0.index == $0.questionsCount }
            ) { $1 ? $0 : true }
            .drive(mainView.submitButton.rx.isHidden)
            .disposed(by: disposeBag)
        

        mainView.nextButton.rx.tap
            .bind(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestingViewController {
    static func make() -> TestingViewController {
        TestingViewController()
    }
}
