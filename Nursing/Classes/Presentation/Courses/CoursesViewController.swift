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
}

// MARK: Make
extension CoursesViewController {
    static func make() -> CoursesViewController {
        CoursesViewController()
    }
}

// MARK: Make
private extension CoursesViewController {
    func goToCourse() {
        let vc = NursingNavigationController(rootViewController: CourseViewController.make())
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
