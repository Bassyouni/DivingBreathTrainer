//
//  Extensions+UIImage.swift
//  DivingBreathTrainer
//
//  Created by TACME MAC on 12/6/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
