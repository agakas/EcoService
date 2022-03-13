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

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
