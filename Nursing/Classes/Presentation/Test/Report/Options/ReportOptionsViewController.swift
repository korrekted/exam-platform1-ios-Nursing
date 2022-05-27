//
//  ReportOptionsViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit
import RxSwift

protocol ReportOptionsViewControllerDelegate: AnyObject {
    func reportOptionsDidTappedReport()
    func reportOptionsDidTappedRestart()
}

final class ReportOptionsViewController: UIViewController {
    weak var delegate: ReportOptionsViewControllerDelegate?
    
    lazy var mainView = ReportOptionsView()
    
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
                    self.delegate?.reportOptionsDidTappedReport()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.restartButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.reportOptionsDidTappedRestart()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ReportOptionsViewController {
    static func make() -> ReportOptionsViewController {
        let vc = ReportOptionsViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}
