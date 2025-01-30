//
//  MostWatchedCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/12/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import Alamofire
import ObjectMapper

class MostWatchedCell: UITableViewCell {

    @IBOutlet weak var comp_name: UILabel!
    @IBOutlet weak var comp_img: UIImageView!
    @IBOutlet weak var rating_bar: CosmosView!
    @IBOutlet weak var follow_view: UIStackView!
    @IBOutlet weak var ads_count_lbl: UILabel!
    @IBOutlet weak var events_count_lbl: UILabel!
    @IBOutlet weak var prods_count_lbl: UILabel!
    @IBOutlet weak var view_count_lbl: UILabel!
    
    @IBOutlet weak var follow_img: UIImageView!
    
    @IBOutlet weak var follow_lbl: UILabel!
    @IBOutlet weak var top_view: UIView!
    
    @IBOutlet weak var stackView: UIView!
   
    @IBOutlet weak var divider: UIView!
    
    @IBOutlet weak var inner_stackview: UIStackView!
    private var id : Int!
    private var user : User?
    private var isFolowed  = 0

    func config(_obj: MostWatchedComps.Result , _user : User){
        self.user = _user
        
        isFolowed = _obj.IsFlowed ?? 0
        comp_name.text = _obj.CompanyName
        view_count_lbl.text = String(describing: _obj.ViewCounts!)
        events_count_lbl.text = String(describing: _obj.CountEvents!)
        prods_count_lbl.text = String(describing: _obj.CountProduct!)
        ads_count_lbl.text = String(describing: _obj.CountADS!)
//
        follow_lbl.text = isFolowed == 0 ? Bundle.main.localizedString(forKey: "folow", value: nil, table: "Default") :
            Bundle.main.localizedString(forKey: "unfolow", value: nil, table: "Default")
    
        if let url = URL(string: _obj.Logo!){
            comp_img.kf.setImage(with: url,
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        }
        
        id = _obj.id
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.followCompany(_:)))
        follow_view.addGestureRecognizer(gestureSwift2AndHigher)
        rating_bar.rating = _obj.AverageRating ?? 0
    }

    
    func config2(_obj: CompaniesData.Items , _user : User){
        self.user = _user
        
        isFolowed = _obj.IsFlowed ?? 0
        follow_lbl.text = isFolowed == 0 ? Bundle.main.localizedString(forKey: "folow", value: nil, table: "Default") :
            Bundle.main.localizedString(forKey: "unfolow", value: nil, table: "Default")
        
        comp_name.text = _obj.CompanyName
        view_count_lbl.text = String(describing: _obj.ViewCounts ?? 0)
        events_count_lbl.text = String(describing: _obj.CountEvents ?? 0)
        prods_count_lbl.text = String(describing: _obj.CountProduct ?? 0)
        ads_count_lbl.text = String(describing: _obj.CountADS ?? 0)
        //
        
        if let logo = _obj.Logo {
         
            if let url = URL(string: logo){
                comp_img.kf.setImage(with: url,
                                     placeholder: nil,
                                     options: [.transition(.fade(1))],
                                     progressBlock: nil,
                                     completionHandler: nil)
            }
            
        }
        
        id = _obj.id
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.followCompany(_:)))
        follow_view.addGestureRecognizer(gestureSwift2AndHigher)
        
        rating_bar.rating = _obj.AverageRating ?? 0
    }

    
    func followCompany(_ sender:UITapGestureRecognizer){
        if UserDefaults.standard.object(forKey: "User") == nil{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
        
        let parameters: Parameters = [
            "CompanyId": id,
            "UserId": user?.result?.id 
        ]
        
        Alamofire.request(isFolowed == 0 ? FOLLOW_COMPANY_URL : UNFOLLOW_COMPANY_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
               // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
               // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                  //      print("JSON: \(json)") // serialized json response
                        //self.follow_view.isHidden = true
                        self.isFolowed = self.isFolowed == 0 ? 5 : 0
                        self.follow_lbl.text = self.isFolowed == 0 ? Bundle.main.localizedString(forKey: "folow", value: nil, table: "Default") :
                            Bundle.main.localizedString(forKey: "unfolow", value: nil, table: "Default")
                        displayToastMessage(Bundle.main.localizedString(forKey: "fav-sucess", value: nil, table: "Default"))
                    }
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
