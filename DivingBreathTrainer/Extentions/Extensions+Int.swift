//
//  Extensions+Int.swift
//  DivingBreathTrainer
//
//  Created by TACME MAC on 12/6/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation

extension Int {
    func getStringTimeFormat() -> String {
        let (minutes, seconds) = secondsToMinutesAndSeconds(seconds: self)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    fileprivate func secondsToMinutesAndSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
