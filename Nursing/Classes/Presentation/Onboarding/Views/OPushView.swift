//
//  OPushView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 11.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OPushView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var imageView = makeImageView()
    lazy var allowButton = makeAllowButton()
    
    private lazy var profileManager = ProfileManagerCore()
    
    private lazy var tokenReceived = PublishRelay<Void>()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        SDKStorage.shared
            .pushNotificationsManager
            .add(observer: self)
        
        AmplitudeManager.shared
            .logEvent(name: "Notifications Screen", parameters: [:])
    }
}

// MARK: PushNotificationsManagerDelegate
extension OPushView: PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(token: String?) {
        SDKStorage.shared
            .pushNotificationsManager
            .remove(observer: self)
        
        scope.notificationKey = token
        
        tokenReceived.accept(Void())
    }
}

// MARK: Private
private extension OPushView {
    func initialize() {
        allowButton.rx.tap
            .subscribe(onNext: {
                SDKStorage.shared
                    .pushNotificationsManager
                    .requestAuthorization()
            })
            .disposed(by: disposeBag)
        
        tokenReceived
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.profileManager
                    .set(testMode: self.scope.testMode,
                         examDate: self.scope.examDate,
                         testMinutes: self.scope.testMinutes,
                         testNumber: self.scope.testNumber,
                         testWhen: self.scope.testWhen,
                         notificationKey: self.scope.notificationKey)
                    .map { true } 
                    .catchAndReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] success in
                guard let self = self else {
                    return
                }
                
                success ? self.onNext() : self.openError()
            })
            .disposed(by: disposeBag)
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.tokenReceived.accept(Void())
        }
        vc?.present(tryAgainVC, animated: true)
    }
}

// MARK: Make constraints
private extension OPushView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 329.scale),
            imageView.widthAnchor.constraint(equalToConstant: 283.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 121.scale : 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            allowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            allowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            allowButton.heightAnchor.constraint(equalToConstant: 60.scale),
            allowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPushView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Push.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 27.scale))
            .lineHeight(32.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Push.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(23.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Push.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAllowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
