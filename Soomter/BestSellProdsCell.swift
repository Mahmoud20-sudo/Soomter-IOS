//
//  BestSellProdsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class BestSellProdsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var title_field: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var discount_lbl: UILabel!
    
    
    var id = 0
    var productFieldId = 0
    var companyId = 0
    var isFavouroite = 0
    var link : String?
    
    func adToCart(user : User){
        if UserDefaults.standard.object(forKey: "User") == nil{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
        
        let parameters: Parameters = [
            "ProductFieldValueId": productFieldId,
            "ProductId": id,
            "UserId": user.result!.id!,
            "Quantitiy": 1
        ]
        
        Alamofire.request(ADD_TO_CART_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //      print("JSON: \(json)") // serialized json response
                        let msg = Bundle.main.localizedString(forKey: "fav-sucess", value: nil, table: "Default")
                        displayToastMessage(msg)
                        
                    }
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func config(_obj: BestProductsData.Result){
        price_lbl.text = "   " + String(describing: _obj.Price!) + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default") + "   "
        title_field.text = _obj.Title
        price_lbl.roundedWithBorder(radius: 8)
        print(price_lbl.intrinsicContentSize.width)
        
        isFavouroite = _obj.IsFavorite!
         id = _obj.Id!
         productFieldId = _obj.ProductFieldValueId!
        companyId = _obj.CompanyId!
        
        
        if let imgPath = _obj.Image{
            if let url = URL(string: imgPath){
            img.kf.setImage(with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)

            }
            
        }
       if let discount = _obj.Discount {
            discount_lbl.isHidden = false
            discount_lbl.text = Bundle.main.localizedString(forKey: "discount", value: nil, table: "Default") + "  \(discount) %"
            discount_lbl.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        }
        if let isFav = _obj.IsFavorite {
            if isFav == 1{
                fav_btn.setImage(UIImage(named: "Ad-Details-Star-Icon"), for: .normal)

            }else{
                fav_btn.tintColor = UIColor.black
            }
        }
    }
    
    func config2(_obj: ProductDetailsData.ListSelectedProducts){
        price_lbl.text = "   " + String(describing: _obj.Price!) + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default") + "   "
        title_field.text = _obj.Title
        price_lbl.roundedWithBorder(radius: 8)
        print(price_lbl.intrinsicContentSize.width)
        
        isFavouroite = _obj.IsFavorite!
        
        id = _obj.Id!
        productFieldId = _obj.ProductFieldValueId!
        companyId = _obj.CompanyId!
        
        
        if let url = URL(string: _obj.Image!){
            img.kf.setImage(with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)
            
        }
        if let discount = _obj.Discount {
            discount_lbl.isHidden = false
            discount_lbl.text = Bundle.main.localizedString(forKey: "discount", value: nil, table: "Default") + "  \(discount) %"
            discount_lbl.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        }
        if let isFav = _obj.IsFavorite {
            if isFav == 1{
                fav_btn.setImage(UIImage(named: "Ad-Details-Star-Icon"), for: .normal)
                
            }else{
                fav_btn.tintColor = UIColor.black
            }
        }
    }
    
    func config3(_obj: CompanyProfileData.ListProducts){
        price_lbl.text = "   " + String(describing: _obj.Price!) + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default") + "   "
        title_field.text = _obj.Title
        price_lbl.roundedWithBorder(radius: 8)
        print(price_lbl.intrinsicContentSize.width)
        
        isFavouroite = _obj.IsFavorite!
        id = _obj.Id!
        productFieldId = _obj.ProductFieldValueId!
        companyId = _obj.CompanyId!
        
        if let url = URL(string: _obj.Image!){
            img.kf.setImage(with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)
            
        }
        if let discount = _obj.Discount {
            discount_lbl.isHidden = false
            discount_lbl.text = Bundle.main.localizedString(forKey: "discount", value: nil, table: "Default") + " \(discount) " + "%"
            discount_lbl.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        }
        if let isFav = _obj.IsFavorite {
            if isFav == 1{
                fav_btn.setImage(UIImage(named: "Ad-Details-Star-Icon"), for: .normal)
                
            }else{
                fav_btn.tintColor = UIColor.black
            }
        }
    }


    
    override func layoutSubviews() {
        var frame = price_lbl.frame
        frame.size.width = price_lbl.intrinsicContentSize.width + 5
        
        frame.origin.x = self.frame.width - frame.size.width - 10
        price_lbl.frame = frame

    }
    
    @IBAction func sharebtn_clk(_ sender: UIButton) {
        let items = [URL(string: "https://www.soomter.com")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)


    }
    
    @IBAction func favbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let loggedUSer = user {
                addFAv(user: loggedUSer)
            }
            
        }else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }
    
    func addFAv(user : User){
        
            let parameters: Parameters = [
                "ProductFieldValueId": productFieldId,
                "UserId": user.result!.id!,
                "ProductId": id,
                "CompanyId": companyId
                 ]
            
            Alamofire.request(isFavouroite > 0 ? UNFAV_PRODUCT_URL : FAV_PRODUCT_URL , method : .post, parameters :
                        parameters , encoding: JSONEncoding.default).responseJSON { response in
                    // print("Request: \(String(describing: response.request))")   // original url request
                    // print("Response: \(String(describing: response.response))") // http url response
                    // print("Result: \(response.result)")                         // response serialization result
                    switch response.result{
                    case .success:
                        if let json = response.result.value {
                            //      print("JSON: \(json)") // serialized json response
                            //self.ow.isHidden = true
                            let msg = Bundle.main.localizedString(forKey: "fav-sucess", value: nil, table: "Default")
                            displayToastMessage(msg)
                            if self.isFavouroite == 0 {
                                self.isFavouroite = 1
                                self.fav_btn.setImage(UIImage(named: "Ad-Details-Star-Icon"), for: .normal)
                            }
                            else{
                                self.isFavouroite = 0
                                self.fav_btn.setImage(UIImage(named: "Unactive-Star-Icon"), for: .normal)
                                self.fav_btn.tintColor = UIColor.black
                                
                            }
                        }
                        break
                    case .failure(let error):
                        displayToastMessage(error.localizedDescription)
                        break
                    }
            
        }
        
        
    }
    
    @IBAction func addto_cartbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let loggedUSer = user {
                adToCart(user: loggedUSer)
            }
            
        }else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }

    
}
