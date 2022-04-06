//
//  OnboardingView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case experience, welcome, quickQuestions, age, goals, whenStudy, modes, time, motivation, improve, count, amazing, testQuestion1, testQuestion2, testQuestion3, testQuestion4, testQuestion5, thankYou, questionsCount, whenTaking, preloader, push
    }
    
    var didFinish: (() -> Void)?
    var didChangedSlide: ((Step) -> Void)?
    
    var step = Step.welcome {
        didSet {
            scroll()
            headerUpdate()
        }
    }
    
    private lazy var scope = OnboardingScope()
    
    lazy var scrollView = makeScrollView()
    lazy var progressView = makeProgressView()
    lazy var previousButton = makePreviousButton()
    
    lazy var test1View = OSlideTestQuestionView(step: .testQuestion1, scope: scope)
    lazy var test2View = OSlideTestQuestionView(step: .testQuestion2, scope: scope)
    lazy var test3View = OSlideTestQuestionView(step: .testQuestion3, scope: scope)
    lazy var test4View = OSlideTestQuestionView(step: .testQuestion4, scope: scope)
    lazy var test5View = OSlideTestQuestionView(step: .testQuestion5, scope: scope)
    lazy var pushView = OPushView(step: .push, scope: scope)
    
    private lazy var contentViews: [OSlideView] = {
        [
            OSlideExperienceView(step: .experience, scope: scope),
            OSlideWelcomeView(step: .welcome, scope: scope),
            OSlideQuickQuestionsView(step:. quickQuestions, scope: scope),
            OSlideAgeView(step: .age, scope: scope),
            OSlideGoalsView(step: .goals, scope: scope),
            OWhenStudyView(step: .whenStudy, scope: scope),
            OSlideModesView(step: .modes, scope: scope),
            OSlideTimeView(step: .time, scope: scope),
            OSlideMotivationView(step: .motivation, scope: scope),
            OSlideImproveView(step: .improve, scope: scope),
            OSlideCountView(step: .count, scope: scope),
            OSlideAmazingView(step: .amazing, scope: scope),
            test1View,
            test2View,
            test3View,
            test4View,
            test5View,
            OSlideThankYouView(step: .thankYou, scope: scope),
            OSlideQuestionsCountView(step: .questionsCount, scope: scope),
            OSlideWhenTakingView(step: .whenTaking, scope: scope),
            OSlidePreloaderView(step: .preloader, scope: scope),
            pushView
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        headerUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var progressCases: [Step] = [
        .age, .goals, .whenStudy, .modes, .time, .motivation, .improve, .count, .amazing, .testQuestion1, .testQuestion2, .testQuestion3, .testQuestion4, .testQuestion5, .thankYou, .questionsCount, .whenTaking
    ]
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        didChangedSlide?(step)
        
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        self.step = nextStep
    }
}

// MARK: Public
extension OnboardingView {
    func slideViewMoveToPrevious(from step: Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        self.step = previousStep
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
        
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                scrollView.addSubview(view)
                
                view.delegate = self
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func scroll() {
        let index = step.rawValue
        
        guard contentViews.indices.contains(index) else {
            return
        }
        
        let view = contentViews[index]
        let frame = contentViews[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
        
        view.moveToThis()
    }
    
    func headerUpdate() {
        switch step {
        case .experience, .welcome, .quickQuestions, .push, .preloader:
            previousButton.isHidden = true
            progressView.isHidden = true
        default:
            previousButton.isHidden = false
            progressView.isHidden = false
        }
        
        guard let index = progressCases.firstIndex(of: step) else {
            return
        }
        progressView.step = index + 1
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 74.scale : 34.scale),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            previousButton.widthAnchor.constraint(equalToConstant: 6.scale),
            previousButton.heightAnchor.constraint(equalToConstant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreviousButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.scale
        view.dy = -10.scale
        view.setImage(UIImage(named: "Onboarding.Previous"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> OStepView {
        let view = OStepView()
        view.count = progressCases.count
        view.step = 1
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
