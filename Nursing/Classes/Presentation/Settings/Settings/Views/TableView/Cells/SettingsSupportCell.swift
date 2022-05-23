//
//  SettingsSupportCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsSupportCell: UITableViewCell {
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
private extension SettingsSupportCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsSupportCell {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension SettingsSupportCell {
    
}
