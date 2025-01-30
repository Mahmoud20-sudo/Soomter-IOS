//
//  ImageExt.swift
//  Soomter
//
//  Created by Mahmoud on 7/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

extension UIView {
    func roundedWithBorder(){
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = hexStringToUIColor(hex: "#E1C79B").cgColor
        
    }

    func roundedWithBorder(color : String){
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = hexStringToUIColor(hex: color).cgColor
        
    }
    
    func roundedWithBorder(color : String ,radius : Float){
        
        layer.cornerRadius = CGFloat(radius)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = hexStringToUIColor(hex: color).cgColor
        
    }

    
    func roundedWithBorder(radius : Float){
        
        layer.cornerRadius = CGFloat(radius)
        layer.masksToBounds = true
        
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
