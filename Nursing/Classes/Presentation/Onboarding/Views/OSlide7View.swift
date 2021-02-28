//
//  OSlide7View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide7View: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var pickerView = makePickerView()
    lazy var minLabel = makeMinLabel()
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIPickerViewDataSource
extension OSlide7View: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        12
    }
}

// MARK: UIPickerViewDelegate
extension OSlide7View: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 95, green: 70, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
        
        label?.attributedText = String((row + 1) * 5).attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
}

// MARK: Private
private extension OSlide7View {
    func initialize() {
        pickerView.reloadAllComponents()
        pickerView.selectRow(3, inComponent: 0, animated: false)
    }
}

// MARK: Make constraints
private extension OSlide7View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 140.scale),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickerView.widthAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            minLabel.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 9.scale),
            minLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            minLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide7View {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide7.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = PaddingPickerView()
        view.padding = UIEdgeInsets(top: 0, left: 200.scale, bottom: 0, right: 200.scale)
        view.backgroundColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMinLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 95, green: 70, blue: 245))
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        
        let view = UILabel()
        view.attributedText = "Onboarding.Slide7.Min".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
