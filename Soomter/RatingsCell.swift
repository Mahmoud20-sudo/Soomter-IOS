//
//  RatingsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/10/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Cosmos

class RatingsCell: UITableViewCell {

    
    @IBOutlet weak var ratetext_lbl: UILabel!
    @IBOutlet weak var rating_bar: CosmosView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var container_view: UIView!

    func config(_obj : ProductDetailsData.ListRating){
        rating_bar.text = String(describing: _obj.Rating!)
        rating_bar.rating = _obj.Rating!
        name_lbl.text = _obj.Name! + " " + _obj.RatingDate!
        ratetext_lbl.text = _obj.Comment
    }
    func config2(_obj: String){
        name_lbl.text = _obj
        ratetext_lbl.text = "سنيبتسايبنتسيابتنسيابتنسايبتنسيبا"
    }
}
