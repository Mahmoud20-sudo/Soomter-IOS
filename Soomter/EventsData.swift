//
//  EventsData.swift
//  Soomter
//
//  Created by Mahmoud on 8/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class EventsData: NSObject ,Mappable {
    
    var status   : Int?
    var error     : String?
    var result    : Result?
    
    override init() {}
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        error<-map["Error"]
        result<-map["Result"]
        status<-map["Status"]
    }
    
    class Result :NSObject , Mappable {
        
        
        var TotalItemsCount : String?
        var Items :[Items]?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Items<-map["Items"]
            TotalItemsCount<-map["TotalItemsCount"]
        }
    }
    
    class Items :NSObject , Mappable {
        
        var Id : Int?
        var Period :String?
        var Image :String?
        var Title :String?
        var Address :String?
        var IsStar :Bool?
        var IsFavorite : Bool?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Period<-map["Period"]
            Image<-map["Image"]
            Title<-map["Title"]
            Address<-map["Address"]
            IsStar<-map["IsStar"]
            IsFavorite<-map["IsFavorite"]
        }
    }
}
