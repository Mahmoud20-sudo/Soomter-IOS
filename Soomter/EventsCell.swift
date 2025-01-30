//
//  EventsCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {

    
    @IBOutlet weak var location_tf: UITextField!
    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var period_tf: UITextField!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var fav_icon: UIImageView!
    @IBOutlet weak var event_img: UIImageView!
    
    func config(_obj: EventsData.Items){
        name_tf.text = _obj.Title
        period_tf.text = _obj.Period
        location_tf.text = _obj.Address
        
        if Locale.preferredLanguages[0] == "en" {
            fav_icon.image = _obj.IsFavorite! ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_icon.image = _obj.IsFavorite! ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }
        
        if let url =  _obj.Image{
            event_img.kf.setImage(with: URL(string: url),
                             placeholder: nil,
                             options: [.transition(.fade(1))],
                             progressBlock: nil,
                             completionHandler: nil)
        }
    }
    
    func config2(_obj: CompanyProfileData.ListEvents){
        name_tf.text = _obj.Title
        //period_tf.text = _obj.Period
        location_tf.text = _obj.CityName

        
        if Locale.preferredLanguages[0] == "en" {
            fav_icon.image = _obj.IsFavorite! ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_icon.image = _obj.IsFavorite! ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }
        
        if let img =  URL(string: "https://soomter.com/AttachmentFiles/\(_obj.ImageId).png"){
            event_img.kf.setImage(with: img,
                                  placeholder: nil,
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
        }
    }

    
    override func layoutSubviews() {
        container.roundedWithBorder(radius: 5)
        event_img.roundedWithBorder(radius: 5)
        event_img.contentMode = .center
        
    }
}
