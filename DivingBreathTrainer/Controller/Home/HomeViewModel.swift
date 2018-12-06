//
//  Homeswift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate {
    func didBeginHoldRound()
    func didBeginBreatheRound()
    func handelTimerRound(forState state: TrainingState)
    func didFinishTraining()
}

enum TrainingState {
    case ready
    case hold
    case breathe
}

class HomeViewModel
{
    //MARK:- variables
    var timer = Timer()
    var count = 0
    var total = 0

    var dataSoruce = [O2TableCellViewModel]()
    var currentIndex: Int = 1
    
    var delegate: HomeViewModelDelegate?
    
    var isInReadyRound: Bool = true
    
    var state: TrainingState = .ready
    
    //MARK:- initalizers
    init() {
        populateDataSource()
    }
    
    var hasContractedInRound: Bool {
        get {
            return dataSoruce[currentIndex].model.hasContracted
        }
        set { dataSoruce[currentIndex].model.hasContracted = newValue }
    }
    
    //MARK:- methods
    func startRound() {
        timer.invalidate()
        
        switch state {
        case .ready:
            total = 5
        case .hold:
            total = dataSoruce[currentIndex].model.holdTime ?? 0
            isInReadyRound = false
        case .breathe:
            total = dataSoruce[currentIndex].model.breathTime ?? 0
            isInReadyRound = false
        }
        
        count = total
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleRoundTimer), userInfo: nil, repeats: true)
    }

    
    @objc func handleRoundTimer() {
        
        if count == total
        {
            switch state {
            case .hold:
                delegate?.didBeginHoldRound()
            case .breathe:
                delegate?.didBeginBreatheRound()
            default:
                break
            }            
        }
        
        count -= 1
        delegate?.handelTimerRound(forState: state)

        if count == 0 {
            handleNextRound()
        }
    }
    
    private func handleNextRound() {
        if !dataSoruce[currentIndex].model.hasHolded {
            state = .hold
            startRound()
            dataSoruce[currentIndex].model.hasHolded = true
        }
        else if !dataSoruce[currentIndex].model.hasBreathed {
            state = .breathe
            startRound()
            dataSoruce[currentIndex].model.hasBreathed = true
        }
        else {
            currentIndex += 1
            if currentIndex < dataSoruce.count {
                handleNextRound()
            }
            else {
                //TODO: handle table Done State
            }
        }
    }
    
    func populateDataSource() {
        
        let hedaerCellViewModel = O2TableCellViewModel(model:O2TableModel(holdTime: nil, breathTime: nil, sequanceNumber: nil))
    
        hedaerCellViewModel.isHeader = true
        dataSoruce.append(hedaerCellViewModel)
        dataSoruce.append(O2TableCellViewModel(model:O2TableModel(holdTime: 45, breathTime: 90, sequanceNumber: 1)))
        dataSoruce.append(O2TableCellViewModel(model:O2TableModel(holdTime: 60, breathTime: 90, sequanceNumber: 2)))
        dataSoruce.append(O2TableCellViewModel(model:O2TableModel(holdTime: 75, breathTime: 90, sequanceNumber: 3)))
        dataSoruce.append(O2TableCellViewModel(model:O2TableModel(holdTime: 90, breathTime: nil, sequanceNumber: 4)))
    }
}
