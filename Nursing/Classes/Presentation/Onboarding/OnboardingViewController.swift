//
//  OnboardingViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    lazy var mainView = OnboardingView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = OnboardingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.questions()
            .drive(onNext: { [weak self] questions in
                self?.fill(questions: questions)
            })
            .disposed(by: disposeBag)
        
        mainView.didFinish = { [weak self] in
            guard let this = self else {
                return
            }
            
            this.markAsViewed()
            
            this.goToNext()
        }
        
        mainView.didChangedSlide = { [weak self] step in
            guard let this = self else {
                return
            }
            
            if step == .age {
                this.goToCourses()
            }
        }
        
        addPreviousAction()
        mainView.pushView.vc = self
    }
}

// MARK: Make
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
}

// MARK: API
extension OnboardingViewController {
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: PaygateViewControllerDelegate
extension OnboardingViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        goToCourseOrCourses()
    }
}

// MARK: Private
private extension OnboardingViewController {
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func fill(questions: [Question]) {
        if questions.indices.contains(0) {
            mainView.test1View.setup(question: questions[0])
        }
        
        if questions.indices.contains(1) {
            mainView.test2View.setup(question: questions[1])
        }
        
        if questions.indices.contains(2) {
            mainView.test3View.setup(question: questions[2])
        }
        
        if questions.indices.contains(3) {
            mainView.test4View.setup(question: questions[4])
        }
        
        if questions.indices.contains(4) {
            mainView.test5View.setup(question: questions[4])
        }
    }
    
    func goToNext() {
        switch viewModel.whatNext() {
        case .paygateBlock:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .paygateSuggest:
            let vc = PaygateViewController.make()
            vc.delegate = self
            present(vc, animated: true)
        case .nextScreen:
            goToCourseOrCourses()
        }
    }
    
    func addPreviousAction() {
        mainView.previousButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.mainView.slideViewMoveToPrevious(from: self.mainView.step)
            })
            .disposed(by: disposeBag)
    }
    
    func goToCourseOrCourses() {
        viewModel.hasSelectedCourse ? goToCourse() : goToCourses()
    }
    
    func goToCourses() {
        let vc = CoursesViewController.make(howOpen: .present)
        present(vc, animated: true)
    }
    
    func goToCourse() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = CourseViewController.make()
    }
}
