//
//  File.swift
//  Soomter
//
//  Created by Mahmoud on 9/3/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation
import ObjectMapper

class EventCountsData: NSObject ,Mappable {
    
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
        
        var Count : Int?
        var Id : Int?
        var Image : String?
        var Name : String?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Count<-map["Count"]
            Id<-map["Id"]
            Image<-map["Image"]
            Name<-map["Name"]
        }
    }
    
    
}
