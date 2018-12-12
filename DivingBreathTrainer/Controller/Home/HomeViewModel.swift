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
    var isInMiddleOfTranning: Bool = false
    
    var state: TrainingState = .ready
    
    //MARK:- initalizers
    init() {
        populateDataSource()
    }
    
    var isTrainerRunning: Bool = false
    
    
    var hasContractedInRound: Bool {
        get {
            return dataSoruce[currentIndex].model.hasContracted
        }
        set { dataSoruce[currentIndex].model.hasContracted = newValue }
    }
    
    var contractionTimeInRound: Int? {
        didSet {
            guard (contractionTimeInRound != nil) else { return }
            dataSoruce[currentIndex].model.contractionTime = contractionTimeInRound
        }
    }
    
    //MARK:- methods
    func startRound() {
        timer.invalidate()
        
        isInMiddleOfTranning = true
        
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
        isTrainerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleRoundTimer), userInfo: nil, repeats: true)
        if state != .ready {
            handleRoundTimer()
        }
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
        if currentIndex < dataSoruce.count
        {
            let cellViewModel = dataSoruce[currentIndex]
            
            if !cellViewModel.model.hasHolded {
                state = .hold
                startRound()
                cellViewModel.model.hasHolded = true
                cellViewModel.isHoldRound = true
                cellViewModel.isBreatheRound = false
            }
            else if !cellViewModel.model.hasBreathed && cellViewModel.model.breathTime != nil
            {
                state = .breathe
                startRound()
                cellViewModel.model.hasBreathed = true
                cellViewModel.isHoldRound = false
                cellViewModel.isBreatheRound = true
            }
            else {
                cellViewModel.isHoldRound = false
                cellViewModel.isBreatheRound = false
                currentIndex += 1
                if currentIndex < dataSoruce.count {
                    handleNextRound()
                }
                else {
                    reset()
                }
            }
        }
    }
    
    fileprivate func reset() {
        timer.invalidate()
        isInMiddleOfTranning = false
        delegate?.didFinishTraining()
        currentIndex = 1
        isInReadyRound = true
        state = .ready
        count = 0
        total = 0
    }
    
    func pauseTrainner()
    {
        timer.invalidate()
        isTrainerRunning = false
    }
    
    func resumeTrainer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleRoundTimer), userInfo: nil, repeats: true)
//        handleRoundTimer()
        isTrainerRunning = true
        
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
