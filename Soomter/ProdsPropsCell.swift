//
//  ProdsPropsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/10/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class ProdsPropsCell: UITableViewCell {

    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var value_lbl: UILabel?
    
    @IBOutlet weak var view: UIView?
    
    func config(_obj : ProductDetailsData.ProductsProperties){
        title_lbl.text = _obj.Value
    }
    func config2(_obj : ProductDetailsData.ProductsProperties){
        title_lbl.text = _obj.Text
        value_lbl?.text = _obj.Value
    }
    func config3(_obj :String){
        title_lbl.text = "اللون"
        value_lbl?.text = _obj
    }

}
