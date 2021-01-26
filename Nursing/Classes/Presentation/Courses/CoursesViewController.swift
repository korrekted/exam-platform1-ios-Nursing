//
//  CoursesViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class CoursesViewController: UIViewController {
    lazy var mainView = CoursesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CoursesViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView
            .collectionView.selected
            .bind(to: viewModel.selected)
            .disposed(by: disposeBag)

        viewModel
            .elements
            .drive(onNext: mainView.collectionView.setup(elements:))
            .disposed(by: disposeBag)
        
        mainView
            .button.rx.tap
            .bind(to: viewModel.store)
            .disposed(by: disposeBag)
        
        viewModel
            .stored
            .drive(onNext: { [weak self] in
                self?.goToCourse()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension CoursesViewController {
    static func make() -> CoursesViewController {
        CoursesViewController()
    }
}

// MARK: Private
private extension CoursesViewController {
    func goToCourse() {
        UIApplication.shared.keyWindow?.rootViewController = CourseViewController.make()
    }
}
