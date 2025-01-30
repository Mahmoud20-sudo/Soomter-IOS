//
//  CitiesCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/15/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import BEMCheckBox

class AddressesCell: UITableViewCell {
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var details_lbl: UILabel!
    
    @IBOutlet weak var radiobtn: BEMCheckBox!
    @IBOutlet weak var number_lbl: UILabel!
    
    var _obj : ProductAddreseData.Result?
    var completionHander :CompletionHandler?
    var _position : Int?
    
    
    @IBAction func editAddresbtn_clk(_ sender: UIButton) {
    }
    
    func config(_obj : ProductAddreseData.Result ,_position : Int ,completionHander :@escaping CompletionHandler){
        self._obj = _obj
        radiobtn.onCheckColor = hexStringToUIColor(hex: "#FFFFFF")
        radiobtn.onFillColor = hexStringToUIColor(hex: "#D9B878")
        radiobtn.onTintColor = hexStringToUIColor(hex: "#FFFFFF")
        radiobtn.boxType = BEMBoxType.circle
        radiobtn.onAnimationType = BEMAnimationType.fill
        radiobtn.offAnimationType = BEMAnimationType.fill
        if _obj.Isdefault! {
         
            _obj.isCheked = true
            
        }
        if(_obj.isCheked){
            name_lbl.textColor = hexStringToUIColor(hex: "#6c6c6c")
        }
        else{
            name_lbl.textColor = hexStringToUIColor(hex: "#BCBEC1")
        }
        
        radiobtn.setOn(_obj.isCheked, animated: true)
        
        self.completionHander = completionHander
        
        self._position = _position
        name_lbl.text = _obj.ReceiverName
        number_lbl.text = _obj.ContactTel
        var fullAdd = ""
        if let address = _obj.Address {
            fullAdd.append(address)
        }
        if let region = _obj.Region {
            fullAdd.append(" - "+region)
        }
        if let numb = _obj.StreetNo{
            fullAdd.append(" - "+numb)
        }
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func selectitem_clk(_ sender: BEMCheckBox) {
        //if _position == 0{
        completionHander!(!(_obj?.isCheked)!)
        //}
        //else{
        //    if (radiobtn.on == false){
        //        radiobtn.setOn(false, animated: true)
        ///    }else{
        //       radiobtn.setOn(true, animated: true)
        //   }
        //}
        
    }
    
}
