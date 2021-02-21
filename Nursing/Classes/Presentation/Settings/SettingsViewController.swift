//
//  SettingsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SettingsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections
            .drive(onNext: mainView.tableView.setup(sections:))
            .disposed(by: disposeBag)
        
        mainView
            .tableView.tapped
            .subscribe(onNext: tapped(_:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        SettingsViewController()
    }
}

// MARK: Private
private extension SettingsViewController {
    func tapped(_ tapped: SettingsTableView.Tapped) {
        switch tapped {
        case .unlock:
            UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
        case .course:
            UIApplication.shared.keyWindow?.rootViewController = CoursesViewController.make(howOpen: .root)
        case .rateUs:
            RateUs.requestReview()
        case .contactUs:
            open(path: GlobalDefinitions.contactUsUrl)
        case .termsOfUse:
            open(path: GlobalDefinitions.termsOfServiceUrl)
        case .privacyPoliicy:
            open(path: GlobalDefinitions.privacyPolicyUrl)
        }
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
