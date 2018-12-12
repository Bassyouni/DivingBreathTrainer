//
//  O2TableViewCell.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class O2TableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var sequanceNumberLabel: UILabel!
    @IBOutlet weak var holdTimeLabel: UILabel!
    @IBOutlet weak var breathTimeLabel: UILabel!
    @IBOutlet weak var contractionTimeLabel: UILabel!
    @IBOutlet weak var playImageViewForHold: UIImageView!
    @IBOutlet weak var playImageViewForBreathe: UIImageView!
    
    //MARK:- static variables
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    //MARK:- variables
    var viewModel: O2TableCellViewModel! {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    // MARK: - initialization
    func configureUI() {
        contractionTimeLabel.isHidden = true
        playImageViewForHold.isHidden = true
        playImageViewForBreathe.isHidden = true
        selectionStyle = .none
    }
    
    func bindUI() {
        
        sequanceNumberLabel.text = viewModel.sequanceNumber
        holdTimeLabel.text = viewModel.holdTime
        breathTimeLabel.text = viewModel.breathTime
        contractionTimeLabel.text = viewModel.contractionTime ?? ""
        contractionTimeLabel.isHidden = viewModel.contractionTime == nil
        playImageViewForHold.isHidden = !viewModel.isHoldRound
        playImageViewForBreathe.isHidden = !viewModel.isBreatheRound
        
    }
}
