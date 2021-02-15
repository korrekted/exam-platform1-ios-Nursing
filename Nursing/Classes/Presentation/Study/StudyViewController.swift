//
//  StudyViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StudyViewController: UIViewController {
    lazy var mainView = StudyView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StudyViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.collectionView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        mainView
            .settingsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.settingsTapped()
            })
            .disposed(by: disposeBag)
        
        mainView
            .collectionView.selected
            .subscribe(onNext: { [weak self] element in
                self?.selected(element: element)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController.make(), animated: true)
    }
    
    func selected(element: StudyCollectionElement) {
        switch element {
        case .brief, .title:
            break
        case .unlockAllQuestions:
            UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
        case .takeTest(let activeSubscription):
            break
        case .mode(let mode):
            tapped(mode: mode.mode)
        }
    }
    
    func tapped(mode: SCEMode.Mode) {
        switch mode {
        case .ten:
            break
        case .random:
            break
        case .missed:
            break
        case .today:
            break
        }
        
        openTest(type: .tenSet)
    }
    
    func openTest(type: TestType) {
        let controller = TestViewController.make(testType: type)
        controller.didTapSubmit = { [weak self] userTestId in
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.present(TestStatsViewController.make(userTestId: userTestId), animated: true)
            })
        }
        present(controller, animated: true)
    }
}
