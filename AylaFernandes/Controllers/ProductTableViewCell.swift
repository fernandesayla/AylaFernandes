//
//  ProductTableViewCell.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/25/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    
    
    @IBOutlet weak var lbDollarPrice: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with product: Product){
        lbName.text = product.name
        lbDollarPrice.text = String(format: "%.2f", product.dollarPrice)
       
        if let image = product.image as? UIImage {
            ivProduct.image = image
        }else{
            ivProduct.image = UIImage(named: "gift")
        }
        
    }
    
    
    
}
