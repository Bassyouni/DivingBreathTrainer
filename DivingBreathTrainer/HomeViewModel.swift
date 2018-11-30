//
//  Homeswift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class HomeViewModel
{
    //MARK:- variables
    var timer = Timer()
    var count = 10
    var total = 10

    var dataSoruce = [O2TableCellViewModel]()
    
    //MARK:- initalizers
    init() {
        populateDataSource()
    }
    
    //MARK:- methods
    func createTrackLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
       return CircleModel.createTrackLayer(strokeColor: strokeColor, fillColor: fillColor)
    }
    
    func getStrokeAnimation() -> CABasicAnimation {
        return CircleModel.animateStroke(duration: CFTimeInterval(total))
    }
    
    func pauseLayer(layer: CALayer) {
        CircleModel.pauseLayer(layer: layer)
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
