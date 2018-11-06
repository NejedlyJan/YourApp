//
//  CustomTableViewCell.swift
//  YourApp
//
//  Created by honza on 05/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var labelColorOutlet: UIView!
    @IBOutlet weak var cellLabelOutlet: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = labelColorOutlet.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            labelColorOutlet.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = labelColorOutlet.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            labelColorOutlet.backgroundColor = color
        }
    }
}
