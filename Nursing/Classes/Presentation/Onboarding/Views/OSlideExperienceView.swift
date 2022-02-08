//
//  OSlideExperienceView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 07.02.2022.
//

import UIKit
import RxSwift

final class OSlideExperienceView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var cellsTitleLabel = makeCellsTitleLabel()
    lazy var cell1 = makeCell1()
    lazy var cell2 = makeCell2()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideExperienceView {
    func initialize() {
        Observable
            .merge(
                cell1.rx.tap.asObservable(),
                cell2.rx.tap.asObservable()
            )
            .subscribe(onNext: { [weak self] in
                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension OSlideExperienceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 84.scale : 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cellsTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellsTitleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 32.scale : 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.widthAnchor.constraint(equalToConstant: 311.scale),
            cell1.heightAnchor.constraint(equalToConstant: 170.scale),
            cell1.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell1.topAnchor.constraint(equalTo: cellsTitleLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.widthAnchor.constraint(equalToConstant: 311.scale),
            cell2.heightAnchor.constraint(equalToConstant: 170.scale),
            cell2.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideExperienceView {
    func makeTitleLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
        
        let attrs2 = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.black(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
        
        let string1 = "Onboarding.Experience.Title.Part1".localized.attributed(with: attrs1)
        let string2 = "Onboarding.Experience.Title.Part2".localized.attributed(with: attrs2)
        
        let string = NSMutableAttributedString()
        string.append(string1)
        string.append(string2)
        
        let view = UILabel()
        view.attributedText = string
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor)
            .font(Fonts.SFProRounded.regular(size: ScreenSize.isIphoneXFamily ? 19.scale : 16.scale))
            .lineHeight(ScreenSize.isIphoneXFamily ? 26.6.scale : 23.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Experience.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCellsTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Experience.CellsTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell1() -> OExperienceCell {
        let view = OExperienceCell()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.image = UIImage(named: "Onboarding.Experience.Cell1")
        view.title = "Onboarding.Experience.Cell1.Title".localized
        view.subTitle = "Onboarding.Experience.Cell1.SubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell2() -> OExperienceCell {
        let view = OExperienceCell()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.image = UIImage(named: "Onboarding.Experience.Cell2")
        view.title = "Onboarding.Experience.Cell2.Title".localized
        view.subTitle = "Onboarding.Experience.Cell2.SubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
