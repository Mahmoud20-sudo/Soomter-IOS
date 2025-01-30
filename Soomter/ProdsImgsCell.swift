//
//  ProdsImgsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/10/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class ProdsImgsCell: UICollectionViewCell {

    @IBOutlet weak var prod_img: UIImageView!
    
    func config(_obj: ProductDetailsData.ImageList){
        
        if let url =  _obj.Image{
            prod_img.kf.setImage(with: URL(string: url),
                                  placeholder: nil,
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
        }
        
    }
}
