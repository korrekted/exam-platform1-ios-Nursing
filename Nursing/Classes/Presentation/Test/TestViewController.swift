//
//  TestViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

final class TestViewController: UIViewController {
    lazy var mainView = TestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((Int) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .bind(to: viewModel.answers)
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .submit ? () : nil }
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .map { $0.questionsCount == 1 }
            .distinctUntilChanged()
            .drive(mainView.progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(mainView) { view, element in
                view.progressView.setProgress(Float(element.index) / Float(element.questionsCount), animated: true)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                viewModel.isEndOfTest,
                mainView.nextButton.rx.tap.asDriver().map { _ in true }
            )
            .drive(Binder(mainView) { view, isHidden in
                let currentBottomInset = view.tableView.contentInset.bottom
                let bottomInset = isHidden ? 0 : view.bounds.height - view.nextButton.frame.minY + 9
                view.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (currentBottomInset + bottomInset).scale, right: 0)
                view.nextButton.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        viewModel.userTestId
            .bind(to: Binder(self) {
                $0.didTapSubmit?($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .drive(Binder(mainView) {
                $0.setupBottomButton(for: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .bind(to: Binder(self) { base, content in
                switch content {
                case let .image(url):
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    do {
                        try imageView.image = UIImage(data: Data(contentsOf: url))
                        let controller = UIViewController()
                        controller.view.backgroundColor = .black
                        controller.view.addSubview(imageView)
                        imageView.frame = controller.view.bounds
                        base.present(controller, animated: true)
                    } catch {
                        
                    }
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit { [weak self] message in
                Toast.notify(with: message, style: .danger)
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.needPayment
            .emit { [weak self] _ in
                self?.dismiss(animated: false, completion: {
                    UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
                })
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType, activeSubscription: Bool) -> TestViewController {
        let controller = TestViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.activeSubscription = activeSubscription
        controller.viewModel.testType.accept(testType)
        return controller
    }
}
