//
//  FoodListTableViewCell.swift
//  NutriMe Project
//
//  Created by Randy Noel on 18/11/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {

  @IBOutlet weak var lblFoodName: UILabel!
  @IBOutlet weak var lblFoodCalorie: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
