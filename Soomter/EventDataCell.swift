//
//  OrgnizersCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/20/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class EventDataCell: UITableViewCell {

     @IBOutlet weak var name_lbl: UILabel!
     @IBOutlet weak var img: UIImageView!
    
    func config(_obj: Informations){
        name_lbl.text = _obj.title
        img.image = UIImage(named: _obj.value)
    }
    
    override func layoutIfNeeded() {
        
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        img.tintColor = hexStringToUIColor(hex: "#8E8E93")
    }
}
