//
//  HeaderCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/19/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var arrow_btn: UIButton!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func arrowbtn_clk(_ sender: UIButton) {
    }
    
}
