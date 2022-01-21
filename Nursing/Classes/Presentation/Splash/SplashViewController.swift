//
//  SplashViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift
import OtterScaleiOS

final class SplashViewController: UIViewController {
    deinit {
        OtterScale.shared.remove(delegate: self)
    }
    
    lazy var mainView = SplashView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SplashViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OtterScale.shared.add(delegate: self)
        
        viewModel.step()
            .drive(onNext: { [weak self] step in
                self?.step(step)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: PaygateViewControllerDelegate
extension SplashViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        step(viewModel.stepAfterPaygateClosed())
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension SplashViewController: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: PaymentData?) {
        viewModel.validationComplete.accept(Void())
    }
}

// MARK: Private
private extension SplashViewController {
    func step(_ step: SplashViewModel.Step) {
        switch step {
        case .onboarding:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = OnboardingViewController.make()
        case .course:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = CourseViewController.make()
        case .paygate:
            let vc = PaygateViewController.make()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}
