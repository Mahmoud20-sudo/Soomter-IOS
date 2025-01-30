//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class PortalBussinsCatgsData: NSObject ,Mappable {
    
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
        
        var id : Int?
        var Name : String?
        var BusinessIcon64 : String?
        var BusinessImage64 : String?
        var EnglishName : String?
        var BusinessImageId : Int?
        var BusinessIconId : Int?
        
        required  init?(map: Map) {
          //  print(map["Email"])
        }
        
        func mapping(map: Map) {
            id<-map["Id"]
            BusinessIcon64<-map["BusinessIcon64"]
            BusinessImageId<-map["BusinessImageId"]
            BusinessImage64<-map["BusinessImage64"]
            BusinessIconId<-map["BusinessIconId"]
            EnglishName<-map["EnglishName"]
            Name<-map["Name"]

        }
    }
}

