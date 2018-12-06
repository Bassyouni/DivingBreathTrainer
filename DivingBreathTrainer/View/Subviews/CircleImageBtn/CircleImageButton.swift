//
//  CircleImageButton.swift
//  DivingBreathTrainer
//
//  Created by TACME MAC on 12/5/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class CircleImageButton: UIButton {
    static let btnWidth: CGFloat = 70
    
    init(image: UIImage, backgroundColor: UIColor) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: CircleImageButton.btnWidth, height: CircleImageButton.btnWidth)) )
        self.setTitle("", for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 30)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = CircleImageButton.btnWidth / 2
        let tintedImage = image.tinted(with: .white)
        imageView?.contentMode = .scaleAspectFit
        self.setImage( tintedImage ?? image , for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
