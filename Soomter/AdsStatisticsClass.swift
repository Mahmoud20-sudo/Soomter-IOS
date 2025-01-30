//
//  AdsStatisticsClass.swift
//  Soomter
//
//  Created by Mahmoud on 8/28/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

class AdsStatisticsClass{
    var name :String?
    var img : String?
    var count: Int?

    init(_name : String, _img: String, _count:Int){
        self.name = _name
        self.img = _img
        self.count = _count
    }
}
