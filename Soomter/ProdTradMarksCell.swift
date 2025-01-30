//
//  ProdTradMarksCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class ProdTradMarksCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name_lbl: UILabel?
   
    func config(_obj: ProductTradmarksData.Result){
        name_lbl?.text = _obj.Name
        
        if let url = URL(string: _obj.Image!){
            img.kf.setImage(with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)
            
        }
    }
    
    func config2(_obj: EventDetailsData.Organizers){
        
        if let url = URL(string: _obj.Image!){
            img.kf.setImage(with: url,
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)
            
        }
    }

}
