//
//  CustomLabel.swift
//  DivingBreathTrainer
//
//  Created by TACME MAC on 12/6/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    init(fontSize: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)) )
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: fontSize)
        textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
