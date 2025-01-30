//
//  ProductTradmarskData.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class ProductTradmarksData: NSObject ,Mappable {
    
    var status   : Int?
    var error     : String?
    var result    : [Result]?
    
    override init() {}
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        error<-map["Error"]
        result<-map["Result"]
        status<-map["Status"]
    }
    
    class Result :NSObject , Mappable {
        
        var Id : Int?
        var Name : String?
        var Image : String?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Image<-map["Image"]
            Name<-map["Name"]
        }
    }
}
