//
//  SettingsCommunityCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsCommunityCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var rateUsButton = makeRateUsButton()
    lazy var joinTheCommunityButton = makeJoinTheCommunityButton()
    lazy var shareWithFriendButton = makeShareWithFriendButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsCommunityCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func rateUsTapped() {
        tableDelegate?.settingsTableDidTappedRateUs()
    }
    
    @objc
    func joinTheCommunityTapped() {
        tableDelegate?.settingsTableDidTappedJoinTheCommunity()
    }
    
    @objc
    func shareWithFriedTapped() {
        tableDelegate?.settingsTableDidTappedShareWithFriend()
    }
}

// MARK: Make constraints
private extension SettingsCommunityCell {
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
            rateUsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            rateUsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            rateUsButton.topAnchor.constraint(equalTo: container.topAnchor),
            rateUsButton.heightAnchor.constraint(equalToConstant: 74.scale)
        ])
        
        NSLayoutConstraint.activate([
            joinTheCommunityButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            joinTheCommunityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            joinTheCommunityButton.topAnchor.constraint(equalTo: rateUsButton.bottomAnchor),
            joinTheCommunityButton.heightAnchor.constraint(equalToConstant: 74.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareWithFriendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            shareWithFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            shareWithFriendButton.topAnchor.constraint(equalTo: joinTheCommunityButton.bottomAnchor),
            shareWithFriendButton.heightAnchor.constraint(equalToConstant: 74.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsCommunityCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Community".localized.attributed(with: attrs)
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
    
    func makeRateUsButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.iconView.image = UIImage(named: "Settings.RateUs")
        view.headerLabel.attributedText = "Settings.Community.RateUs.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.RateUs.SubTitle".localized.attributed(with: subTitleAttrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(rateUsTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeJoinTheCommunityButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.headerLabel.attributedText = "Settings.Community.JoinTheCommunity.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.JoinTheCommunity.SubTitle".localized.attributed(with: subTitleAttrs)
        view.iconView.image = UIImage(named: "Settings.JoinTheCommunity")
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(joinTheCommunityTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeShareWithFriendButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.headerLabel.attributedText = "Settings.Community.ShareWithFriend.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.ShareWithFriend.SubTitle".localized.attributed(with: subTitleAttrs)
        view.iconView.image = UIImage(named: "Settings.ShareWithFriend")
        view.separator.isHidden = true
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(shareWithFriedTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
