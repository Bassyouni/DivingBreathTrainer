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
    
    //MARK:- static variables
    static var cellIdentifier: String {
        return "O2TableViewCell"
    }
    
    //MARK:- variables
    var viewModel: O2TableCellViewModel! {
        didSet {
            bindUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI() {
        
    }
    
    func bindUI() {
        if viewModel.isHeader {
            sequanceNumberLabel.text = ""
            holdTimeLabel.text = "Hold"
            breathTimeLabel.text = "Breath"

        }
        else {
            sequanceNumberLabel.text = viewModel.sequanceNumber
            holdTimeLabel.text = viewModel.holdTime
            breathTimeLabel.text = viewModel.breathTime
        }
    }
}
