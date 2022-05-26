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
    lazy var mainView = TestView(testType: testType)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((Int) -> Void)?
    
    private let testType: TestType
    
    private init(testType: TestType) {
        self.testType = testType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let courseName = viewModel.courseName
        
        viewModel.loadTestActivityIndicator
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                self.mainView.tableView.isHidden = activity
                activity ? self.mainView.activityView.startAnimating() : self.mainView.activityView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendAnswerActivityIndicator
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                activity ? self.mainView.bottomView.preloader.start() : self.mainView.bottomView.preloader.stop()
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .withLatestFrom(courseName) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (answers, name) = stub
                
                self?.viewModel.answers.accept(answers)
                self?.logTapAnalytics(courseName: name, what: "answer")
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomView.bottomButton.rx.tap
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
                FirebaseManager.shared.logEvent(name: "client_test_finished")
            })
            .disposed(by: disposeBag)
        
        mainView.bottomView.nextButton.rx.tap
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.viewModel.didTapNext.accept(Void())
                self?.logTapAnalytics(courseName: name, what: "continue")
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .withLatestFrom(courseName)
            .bind(to: Binder(self) { base, name in
                base.logTapAnalytics(courseName: name, what: "close")
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(onNext: { [weak self] element in
                self?.updateProgress(questionElement: element)
            })
            .disposed(by: disposeBag)
        
        let testMode = viewModel.testMode
            .startWith(nil)
        
        let isHiddenNext = Driver
            .merge(
                viewModel.isEndOfTest.withLatestFrom(testMode) { ($0, $1) },
                mainView.bottomView.nextButton.rx.tap.asDriver().map { _ in (true, nil) }
            )
        
        isHiddenNext
            .drive(onNext: { [weak self] stub in
                let (isHidden, testMode) = stub
                
                if testMode == .onAnExam {
                    self?.viewModel.didTapNext.accept(Void())
                } else {
                    self?.mainView.bottomView.nextButton.isHidden = isHidden
                }
            })
            .disposed(by: disposeBag)
        
        let nextOffset = isHiddenNext
            .map { $0.0 }
            .map { isHidden -> CGFloat in
                return isHidden ? 90.scale : 140.scale
            }
        
        let bottomViewData = viewModel.bottomViewState
            .startWith(.hidden)
        
        let bottomButtonOffset = bottomViewData
            .map { $0 == .hidden ? 90 : 140.scale }
        
        bottomViewData
            .drive(Binder(mainView.bottomView) {
                $0.setup(state: $1)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(nextOffset, bottomButtonOffset) { max($0, $1) }
            .distinctUntilChanged()
            .drive(Binder(mainView.tableView) {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $1, right: 0)
            })
            .disposed(by: disposeBag)
        
        viewModel.userTestId
            .withLatestFrom(courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, stub in
                let (id, name) = stub
                
                base.didTapSubmit?(id)
                base.logTapAnalytics(courseName: name, what: "finish test")
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .bind(to: Binder(self) { base, content in
                switch content {
                case let .image(url):
                    let controller = PhotoViewController.make(imageURL: url)
                    base.present(controller, animated: true)
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

        viewModel.needPayment
            .filter { $0 }
            .emit { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
                })
            }
            .disposed(by: disposeBag)
            
        viewModel.needPayment
            .filter(!)
            .withLatestFrom(courseName)
            .emit(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.logTapAnalytics(courseName: name, what: "media")
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { [.submit, .back].contains($0) }
            .withLatestFrom(viewModel.needPayment)
            .subscribe(onNext: { needPayment in
                guard !needPayment else { return }
                RateManagerCore().showFirstAfterPassRateAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType, activeSubscription: Bool) -> TestViewController {
        let controller = TestViewController(testType: testType)
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.activeSubscription = activeSubscription
        controller.viewModel.testType.accept(testType)
        return controller
    }
}

// MARK: Private
private extension TestViewController {
    func updateProgress(questionElement: QuestionElement) {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        if testType.isQotd() {
            mainView.titleLabel.attributedText = "Question.TodayTitle".localized.attributed(with: attrs)
        } else {
            let title = String(format: "Question.QuestionProgress".localized,
                               questionElement.index,
                               questionElement.questionsCount)
            mainView.titleLabel.attributedText = title.attributed(with: attrs)
            
            mainView.progressView.setProgress(Float(questionElement.index) / Float(questionElement.questionsCount), animated: true)
        }
    }
    
    func logAnalytics(courseName: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        AmplitudeManager.shared
            .logEvent(name: "Question Screen", parameters: ["course": courseName,
                                                            "mode": name])
    }
    
    func logTapAnalytics(courseName: String, what: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        AmplitudeManager.shared
            .logEvent(name: "Question Tap", parameters: ["course": courseName,
                                                         "mode": name,
                                                         "what": what])
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
