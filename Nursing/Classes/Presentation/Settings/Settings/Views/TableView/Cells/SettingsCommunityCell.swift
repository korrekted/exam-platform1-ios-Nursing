//
//  SettingsCommunityCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsCommunityCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
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
}

// MARK: Make constraints
private extension SettingsCommunityCell {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension SettingsCommunityCell {
    
}
