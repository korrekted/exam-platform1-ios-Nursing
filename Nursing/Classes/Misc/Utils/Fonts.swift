//
//  Fonts.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: SFProRounded
    struct SFProRounded {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SF-Pro-Rounded-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SF-Pro-Rounded-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SF-Pro-Rounded-Semibold", size: size)!
        }
    }
}
