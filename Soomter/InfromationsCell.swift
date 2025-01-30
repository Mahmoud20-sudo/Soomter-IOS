//
//  EventInfromsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/2/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class InfromationsCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var rounded_view: UIView!
    
    func config(_name: String , _img :String){
    
        name_lbl.text = _name
        img.image = UIImage(named: _img)
    }

    override func layoutSubviews() {
       rounded_view.roundedWithBorder(radius: 10)
    }
}
