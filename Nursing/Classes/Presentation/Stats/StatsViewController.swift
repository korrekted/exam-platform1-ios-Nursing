//
//  StatsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StatsViewController: UIViewController {
    lazy var mainView = StatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StatsViewModel()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension StatsViewController {
    static func make() -> StatsViewController {
        StatsViewController()
    }
}
