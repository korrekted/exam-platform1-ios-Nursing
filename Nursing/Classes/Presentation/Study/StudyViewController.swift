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
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Study.Settings"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(settingsTapped))
        vc.navigationItem.title = "asdsd"
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    @objc
    func settingsTapped() {
        
    }
}
