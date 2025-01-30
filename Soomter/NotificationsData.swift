//
//  BestProductsData.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class NotificationsData: NSObject ,Mappable {
    
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
        
        var TotalItemsCount : Int?
        var Items : [Items]?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            TotalItemsCount<-map["TotalItemsCount"]
            Items<-map["Items"]
        }
    }
    
    class Items :NSObject , Mappable {
        var Id : Int?
        var Title : String?
        var Image : String?
        var MessageBody : String?
        var ShortMessageBody : String?
        var CreateDate : String?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Image<-map["Image"]
            MessageBody<-map["MessageBody"]
            ShortMessageBody<-map["ShortMessageBody"]
            CreateDate<-map["CreateDate"]
        }
    }

}
