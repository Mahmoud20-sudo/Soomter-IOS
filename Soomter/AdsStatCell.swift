//
//  AdsStatCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class AdsStatCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var count_lbl: UILabel!
    @IBOutlet weak var name_lbl: UILabel?
    
    
    
    func config(_obj : AdsStatisticsClass){
        
        name_lbl?.text = _obj.name
        count_lbl.text = "\(String(describing: _obj.count!))"
//        print(_obj)
        img.image = UIImage(named: _obj.img!)
        
    }

    
    func config(_obj : EventCountsData.Result){
        
        name_lbl?.text = _obj.Name
        count_lbl.text = "\(String(describing: _obj.Count!))"
        //        print(_obj)
        
        if let url = _obj.Image{
            self.img.kf.setImage(with: URL(string: url),
                                       placeholder: nil,
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil,
                                       completionHandler: nil)
        }

     }

}
