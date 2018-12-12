//
//  O2TableCellViewModel.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation

class O2TableCellViewModel
{
    var model: O2TableModel
    var isHeader: Bool = false
    var isBreatheRound: Bool = false
    var isHoldRound: Bool = false
    
    var cellIdentifier: String {
        return O2TableViewCell.cellIdentifier
    }
    
    var sequanceNumber: String {
        get {
            guard let sequanceNumber = model.sequanceNumber else {
                return isHeader ? "" : "-"
            }
            return "\(sequanceNumber)"
        }
    }
    
    var breathTime: String {
        get {
            guard let breathTime = model.breathTime else {
                return isHeader ? "Breathe" : "-"
            }
            return breathTime.getStringTimeFormat()
        }
    }
    
    var holdTime: String {
        get {
            guard let holdTime = model.holdTime else {
                return isHeader ? "Hold" :  "-"
            }
            return holdTime.getStringTimeFormat()
        }
    }
    
    var contractionTime: String? {
        get {
            guard let contractionTime = model.contractionTime else {
                return nil
            }
            return contractionTime.getStringTimeFormat()
        }
    }
    
    init(model: O2TableModel) {
        self.model = model
    }
}

