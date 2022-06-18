//
//  QuizesViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

import UIKit
import RxSwift

final class QuizesViewController: UIViewController {
    lazy var mainView = QuizesView()
    
    private lazy var viewModel = QuizesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension QuizesViewController {
    static func make() -> QuizesViewController {
        QuizesViewController()
    }
}

// MARK: QuizesTableViewDelegate
extension QuizesViewController: QuizesTableViewDelegate {
    func quizesTableDidTapped(quiz: QuizesTableQuiz) {
        let vc = TestStatsViewController.make(userTestId: quiz.id, testType: quiz.type)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension QuizesViewController {
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func activity(_ activity: Bool) {
        let empty = mainView.tableView.elements.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
