//
//  giziTableViewCell.swift
//  NutriMe Project
//
//  Created by Randy Noel on 15/11/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

protocol DetailAction {
  func detailActionClicked()
}

class giziTableViewCell: UITableViewCell {

  
  @IBOutlet weak var pvLemak: UIProgressView!
  
  @IBOutlet weak var pvProtein: UIProgressView!
  @IBOutlet weak var pvKarbo: UIProgressView!
  
  var delegate: DetailAction?
  @IBAction func detailAction(_ sender: Any) {
    delegate?.detailActionClicked()
    print("INININININI")
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
