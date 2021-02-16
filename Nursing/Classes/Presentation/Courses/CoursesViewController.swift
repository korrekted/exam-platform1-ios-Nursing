//
//  CoursesViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class CoursesViewController: UIViewController {
    enum HowOpen {
        case root, present
    }
    
    lazy var mainView = CoursesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CoursesViewModel()
    
    private let howOpen: HowOpen
    
    private init(howOpen: HowOpen) {
        self.howOpen = howOpen
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                self?.goToNext()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension CoursesViewController {
    static func make(howOpen: HowOpen) -> CoursesViewController {
        CoursesViewController(howOpen: howOpen)
    }
}

// MARK: Private
private extension CoursesViewController {
    func goToNext() {
        switch howOpen {
        case .root:
            UIApplication.shared.keyWindow?.rootViewController = CourseViewController.make()
        case .present:
            dismiss(animated: true)
        }
    }
}
