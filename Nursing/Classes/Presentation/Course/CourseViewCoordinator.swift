//
//  CourseViewCoordinator.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class CourseViewCoordinator {
    weak var parentVC: CourseViewController?
    
    lazy var studyVC = StudyViewController.make()
    lazy var statsVC = StatsViewController.make()
    
    private var previousVC: UIViewController?
    
    init(parentVC: CourseViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        switch tab {
        case .study:
            parentVC?.mainView.tabView.selectedTab = tab
            
            changeVC(on: studyVC)
        case .stats:
            parentVC?.mainView.tabView.selectedTab = tab
            
            changeVC(on: statsVC)
        }
    }
}

// MARK: Private
private extension CourseViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
