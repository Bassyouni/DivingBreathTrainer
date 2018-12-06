//
//  O2TableModel.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation


struct O2TableModel {
    var holdTime: Int?
    var breathTime: Int?
    var sequanceNumber: Int?
    var contractionTime: Int?
    
    var hasHolded: Bool = false
    var hasBreathed: Bool = false
    var hasContracted: Bool = false
    
    init(holdTime: Int?, breathTime: Int?, sequanceNumber: Int?) {
        self.holdTime = holdTime
        self.breathTime = breathTime
        self.sequanceNumber = sequanceNumber
    }
}

