//
//  StatsView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class StatsView: UIView {
    
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension StatsView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
}

// MARK: Make constraints
private extension StatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsView {
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

