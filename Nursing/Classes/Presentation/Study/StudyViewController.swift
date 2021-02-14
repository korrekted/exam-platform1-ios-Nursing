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
        
        addNavItemActions()
    }
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        let item = UIBarButtonItem()
        item.image = UIImage(named: "Study.Settings")
        item.tintColor = UIColor(integralRed: 95, green: 70, blue: 245)
        vc.navigationItem.rightBarButtonItem = item
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    func addNavItemActions() {
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] event in
                self?.settingsTapped()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func settingsTapped() {
        let controller = TestViewController.make(testType: .tenSet)
        controller.didTapSubmit = { [weak self] userTestId in
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.present(TestStatsViewController.make(userTestId: userTestId), animated: true)
            })
        }
        present(controller, animated: true)
//        navigationController?.pushViewController(SettingsViewController.make(), animated: true)
    }
}
