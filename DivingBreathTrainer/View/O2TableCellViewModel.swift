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
    
    var cellIdentifier: String {
        return O2TableViewCell.cellIdentifier
    }
    
    var sequanceNumber: String {
        get {
            guard let sequanceNumber = model.sequanceNumber else {
                return "-"
            }
            return "\(sequanceNumber)"
        }
    }
    
    var breathTime: String {
        get {
            guard let breathTime = model.breathTime else {
                return "-"
            }
            return getBreathTimeString(for: breathTime)
        }
    }
    
    var holdTime: String {
        get {
            guard let holdTime = model.holdTime else {
                return "-"
            }
            return getBreathTimeString(for: holdTime)
        }
    }
    
    fileprivate func getBreathTimeString(for time: Int) -> String {
        let (minutes, seconds) = secondsToMinutesAndSeconds(seconds: time)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    fileprivate func secondsToMinutesAndSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    init(model: O2TableModel) {
        self.model = model
    }
}
