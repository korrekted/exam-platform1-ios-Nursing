//
//  SettingsPremiumCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsPremiumCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var container = makeContainer()
    lazy var memberSincePlaceholderLabel = makePlaceholderLabel(title: "Settings.Premium.MemberSince".localized)
    lazy var memberSinceValueLabel = makeLabel()
    lazy var separator = makeSeparator()
    lazy var validTillPlaceholderLabel = makePlaceholderLabel(title: "Settings.Premium.ValidTill".localized)
    lazy var validTillValueLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsPremiumCell {
    func setup(element: SettingsPremium) {
        titleLabel.attributedText = element.title
            .attributed(with: TextAttributes()
                        .textColor(Appearance.blackColor)
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale))
        
        memberSinceValueLabel.attributedText = element.memberSince
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
                        .font(Fonts.SFProRounded.regular(size: 17.scale))
                        .lineHeight(20.scale))
        
        validTillValueLabel.attributedText = element.validTill
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
                        .font(Fonts.SFProRounded.regular(size: 17.scale))
                        .lineHeight(20.scale))
    }
}

// MARK: Private
private extension SettingsPremiumCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsPremiumCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            memberSincePlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31.scale),
            memberSincePlaceholderLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            memberSinceValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28.scale),
            memberSinceValueLabel.centerYAnchor.constraint(equalTo: memberSincePlaceholderLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.topAnchor.constraint(equalTo: container.topAnchor, constant: 49.scale)
        ])
        
        NSLayoutConstraint.activate([
            validTillPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31.scale),
            validTillPlaceholderLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            validTillValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28.scale),
            validTillValueLabel.centerYAnchor.constraint(equalTo: validTillPlaceholderLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsPremiumCell {
    func makePlaceholderLabel(title: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.blackColor.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
