//
//  Extensions.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit

extension UIFont{
    enum FontType: String {
        case logo = "Kepler-296"
        case main = "MusticaPro-SemiBold"
        case contemp = "StretchProRegular"
    }
    static func font(_ size: CGFloat, _ type: FontType) -> UIFont{
        return UIFont(name: type.rawValue, size: size)!
    }
}
