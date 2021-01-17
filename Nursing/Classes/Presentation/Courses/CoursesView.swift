//
//  CoursesView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class CoursesView: UIView {
    lazy var label = makeLabel()
    
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
private extension CoursesView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
}

// MARK: Make constraints
private extension CoursesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CoursesView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.text = "CoursesView"
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
