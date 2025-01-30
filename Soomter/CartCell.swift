//
//  CartCell.swift
//  Soomter
//
//  Created by Mahmoud on 10/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var freeship_lbl: UILabel!
    @IBOutlet weak var minus_icon: UIButton!
    @IBOutlet weak var plus_icon: UIButton!
    @IBOutlet weak var quantity_tf: UITextField!
    @IBOutlet weak var buyername_lbl: UILabel!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var product_img: UIImageView!
    
    var delgeatDeleting : DeletationDelegeat!
    var objec : CartData.Items!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func awakeFromNib() {
        container.roundedWithBorder(radius: 13)
        minus_icon.layer.cornerRadius = minus_icon.bounds.size.width / 2.0
        minus_icon.clipsToBounds = true
        plus_icon.layer.cornerRadius = plus_icon.bounds.size.width / 2.0
        plus_icon.clipsToBounds = true
        
    }
    
    func config(_obj: CartData.Items){
        objec = _obj
        name_lbl.text = _obj.Title
        buyername_lbl.text = _obj.CompanyName
        freeship_lbl.isHidden = _obj.FreeShipping!
        price_lbl.text = "\(_obj.Price ?? 0)" + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        quantity_tf.text =  "\(_obj.ItemQuantity!)"
        if let url = URL(string: "https://soomter.com/AttachmentFiles/\(_obj.ImageId).png"){
            
            product_img.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
            
        }
    }
    
    @IBAction func deletbtn_clk(_ sender: UIButton) {
        
        delgeatDeleting.deleteItem(id: objec.Id!)
    }
    @IBAction func minusicn_clk(_ sender: UIButton) {
        
        if let txt = quantity_tf.text{
            
            
            var qunt = (Int(txt) ?? 1) - 1
            if qunt <= 0{
                return
            }
            quantity_tf.text = "\(qunt)"
        }
    }
    @IBAction func plusicn_clk(_ sender: UIButton) {
        if let txt = quantity_tf.text{
            
            
            var qunt = (Int(txt) ?? 1) + 1
            if qunt <= 0{
                return
            }
            quantity_tf.text = "\(qunt)"
        }
    }
}
