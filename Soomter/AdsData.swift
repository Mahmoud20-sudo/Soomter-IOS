//
//  AdsData.swift
//  Soomter
//
//  Created by Mahmoud on 8/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class AdsData: NSObject ,Mappable {
    
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
        
        var PromotedAds : [AdsClass]?
        var ImageAds : [AdsClass]?
        var VideoAds : [AdsClass]?
        var TextAds : [AdsClass]?
        
        required  init?(map: Map) {
          //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            PromotedAds<-map["PromotedAds"]
            ImageAds<-map["ImageAds"]
            VideoAds<-map["VideoAds"]
            TextAds<-map["TextAds"]
        }
    }
    
    class AdsClass :NSObject , Mappable {
        
        var id : Int?
        var Title : String?
        var CompanyId : Int?
        var TitleKey : String?
        var VedioUrl : String?
        var IsIdentified : Int?
        var type : Int?
        var ImageId : Int?
        var Image : String?
        
        required  init?(map: Map) {
          //  print(map["Id"])
        }
        
        func mapping(map: Map) {
            id<-map["Id"]
            Title<-map["Title"]
            CompanyId<-map["CompanyId"]
            TitleKey<-map["TitleKey"]
            IsIdentified<-map["IsIdentified"]
            type<-map["Type"]
            ImageId<-map["ImageId"]
            Image<-map["Image"]
        }
    }

}
