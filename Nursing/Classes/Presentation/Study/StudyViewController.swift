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
        
        let activeSubscription = viewModel.activeSubscription
        
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
            .withLatestFrom(activeSubscription) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (element, activeSubscription) = stub
                
                self?.selected(element: element, activeSubscription: activeSubscription)
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
    
    func selected(element: StudyCollectionElement, activeSubscription: Bool) {
        switch element {
        case .brief, .title:
            break
        case .unlockAllQuestions:
            openPaygate()
        case .takeTest(let activeSubscription, let configs):
            tappedTakeTest(activeSubscription: activeSubscription, configs: configs)
        case .mode(let mode):
            tapped(mode: mode.mode, activeSubscription: activeSubscription)
        }
    }
    
    func tappedTakeTest(activeSubscription: Bool, configs: [TestConfig]) {
        switch activeSubscription {
        case true:
            openTest(type: .get(testId: nil), activeSubscription: activeSubscription)
        case false:
            let freeConfigs = configs.filter { !$0.paid }
            
            guard let freeTestId = freeConfigs.randomElement()?.id else {
                return
            }
            
            openTest(type: .get(testId: freeTestId), activeSubscription: activeSubscription)
        }
    }
    
    func tapped(mode: SCEMode.Mode, activeSubscription: Bool) {
        switch mode {
        case .ten:
            openTest(type: .tenSet, activeSubscription: activeSubscription)
        case .random:
            openTest(type: .randomSet, activeSubscription: activeSubscription)
        case .missed:
            openTest(type: .failedSet, activeSubscription: activeSubscription)
        case .today:
            openTest(type: .qotd, activeSubscription: activeSubscription)
        }
    }
    
    func openTest(type: TestType, activeSubscription: Bool) {
        let controller = TestViewController.make(testType: type, activeSubscription: activeSubscription)
        controller.didTapSubmit = { [weak self] userTestId in
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.present(TestStatsViewController.make(userTestId: userTestId), animated: true)
            })
        }
        present(controller, animated: true)
    }
    
    func openPaygate() {
        UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
    }
}
