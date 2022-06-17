//
//  ReviewViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit
import RxSwift

final class ReviewViewController: UIViewController {
    lazy var mainView = ReviewView()
    
    private lazy var viewModel = ReviewViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension ReviewViewController {
    static func make() -> ReviewViewController {
        ReviewViewController()
    }
}
