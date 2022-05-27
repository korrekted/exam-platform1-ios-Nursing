//
//  TestOptionsViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit
import RxSwift

protocol TestOptionsViewControllerDelegate: AnyObject {
    func testOptionsDidTappedReport()
    func testOptionsDidTappedRestart()
}

final class TestOptionsViewController: UIViewController {
    weak var delegate: TestOptionsViewControllerDelegate?
    
    lazy var mainView = TestOptionsView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.reportButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.testOptionsDidTappedReport()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.restartButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.testOptionsDidTappedRestart()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestOptionsViewController {
    static func make() -> TestOptionsViewController {
        let vc = TestOptionsViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}
