//
//  AdsInformsCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class AdsInformsCell: UITableViewCell {

    @IBOutlet weak var name_lbl: UILabel!
    func config(_name :String){
        name_lbl.text = _name
    }
}
