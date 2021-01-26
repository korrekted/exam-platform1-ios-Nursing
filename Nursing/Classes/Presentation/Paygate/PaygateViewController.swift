//
//  PaygateViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 18.01.2021.
//

import UIKit
import RxSwift

final class PaygateViewController: UIViewController {
    lazy var button = UIButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("close", for: .normal)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 300.scale),
            button.heightAnchor.constraint(equalToConstant: 50.scale),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
