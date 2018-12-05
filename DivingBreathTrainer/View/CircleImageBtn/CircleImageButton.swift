//
//  CircleImageButton.swift
//  DivingBreathTrainer
//
//  Created by TACME MAC on 12/5/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class CircleImageButton: UIButton {
    let btnWidth: CGFloat = 65
    
    init(image: UIImage, backgroundColor: UIColor) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: btnWidth, height: btnWidth)) )
        self.setTitle("", for: .normal)
        self.setImage( image , for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 30)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = btnWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
