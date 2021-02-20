//
//  OnboardingAnalytics.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.02.2021.
//

final class OnboardingAnalytics {
    func log(step: OnboardingView.Step) {
        let name: String
        
        switch step {
        case .slide1:
            name = "Welcome Screen"
        case .slide2:
            name = "Gender Screen"
        case .slide3:
            name = "Age Screen"
        case .slide4:
            name = "Goals Screen"
        case .slide5:
            name = "When Exam Screen"
        case .slide6:
            name = "Level Screen"
        case .slide7:
            name = "Test Time Screen"
        case .slide8:
            name = "Tests Number Screen"
        case .slide9:
            name = "Improve Screen"
        case .slide10:
            name = "Question 1 Screen"
        case .slide11:
            name = "Question 2 Screen"
        case .slide12:
            name = "Question 3 Screen"
        case .slide13:
            name = "Question 4 Screen"
        case .slide14:
            name = "Plan Preparing Screen"
        case .slide15:
            name = "Personal Plan Screen"
        }
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: [:])
    }
}
