//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class TopDownAdsData: NSObject ,Mappable {
    
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
        
        var TitleKey : String?
        var CompanyId : Int?
        var Url : String?
        var Image : String?
    
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            CompanyId<-map["CompanyId"]
            TitleKey<-map["TitleKey"]
            Url<-map["Url"]
            Image<-map["Image"]
        }
    }
}

