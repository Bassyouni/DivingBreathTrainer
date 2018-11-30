//
//  O2TableViewCell.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class O2TableViewCell: UITableViewCell {
    @IBOutlet weak var sequanceNumberLabel: UILabel!
    @IBOutlet weak var holdTimeLabel: UILabel!
    @IBOutlet weak var breathTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    func configureUI() {
        
    }
    
    func bindUI() {
        
    }
}
