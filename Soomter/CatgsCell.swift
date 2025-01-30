//
//  CatgsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/3/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class CatgsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    func config(_obj: PortalBussinsCatgsData.Result){
        
        name_lbl.text = Locale.preferredLanguages[0] == "en" ? _obj.EnglishName :
            _obj.Name
        
        img.kf.setImage(with: URL(string: (_obj.BusinessIcon64)!),
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)    }
   
}
