//
//  StatesTableViewCell.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 5/4/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit

class StatesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with state: States){
        lbState.text = state.name
        lbTax.text = String(format: "%.2f", state.tax)
 
        
    }
}
