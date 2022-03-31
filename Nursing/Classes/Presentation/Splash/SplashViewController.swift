//
//  SplashViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import OtterScaleiOS

final class SplashViewController: UIViewController {
    var tryAgain: (() -> Void)?
    
    lazy var mainView = SplashView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SplashViewModel()
    
    private let generateStep: Signal<Bool>
    
    private lazy var validationObserver = SplashReceiptValidationObserver()
    
    private init(generateStep: Signal<Bool>) {
        self.generateStep = generateStep
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.step()
            .drive(onNext: { [weak self] step in
                self?.step(step)
            })
            .disposed(by: disposeBag)
        
        let validationObserve = Single<Void>
            .create { [weak self] event in
                guard let self = self else {
                    return Disposables.create()
                }
                
                self.validationObserver.observe {
                    event(.success(Void()))
                }
                
                return Disposables.create()
            }
            .asSignal(onErrorSignalWith: .empty())
        
        Signal.combineLatest(validationObserve, generateStep)
            .map { $1 }
            .emit(onNext: { [weak self] successInitializeSDK in
                guard let self = self else {
                    return
                }
                
                if successInitializeSDK {
                    self.viewModel.validationComplete.accept(Void())
                } else {
                    self.openErrorScreen()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SplashViewController {
    static func make(generateStep: Signal<Bool>) -> SplashViewController {
        SplashViewController(generateStep: generateStep)
    }
}

// MARK: PaygateViewControllerDelegate
extension SplashViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        step(.course)
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
    
    func openErrorScreen() {
        let vc = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.tryAgain?()
        }
        present(vc, animated: true)
    }
}
