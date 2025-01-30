//
//  CartItemsDetCell.swift
//  Soomter
//
//  Created by Mahmoud on 10/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class CartItemsDetCell: UITableViewCell {
   
    @IBOutlet weak var quantity_lbl: UILabel!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var name_lbl: UILabel!
    
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var prod_img: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(_obj: CartData.Items){
        //objec = _obj
        name_lbl.text = _obj.Title
        //buyername_lbl.text = _obj.CompanyName
        //freeship_lbl.isHidden = _obj.FreeShipping!
        price_lbl.text = "\(_obj.Price ?? 0)" + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        quantity_lbl.text =  "\(_obj.ItemQuantity!)"
        if let url = URL(string: "https://soomter.com/AttachmentFiles/\(_obj.ImageId).png"){
            
            prod_img.kf.setImage(with: url,
                                    placeholder: nil,
                                    options: [.transition(.fade(1))],
                                    progressBlock: nil,
                                    completionHandler: nil)
            
        }
    }
    
}
