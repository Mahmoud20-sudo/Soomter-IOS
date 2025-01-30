//
//  InformsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/17/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class InformsCell: UITableViewCell {

    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var value_lbl: UILabel!

    func config(obje : Informations){
        title_lbl.text = obje.title
        
        self.title_lbl.numberOfLines = 0
        self.title_lbl.lineBreakMode = .byWordWrapping
        self.title_lbl.sizeToFit()
        
        value_lbl.text = obje.value
    }
    
}
