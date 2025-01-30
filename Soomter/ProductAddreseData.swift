//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class ProductAddreseData: NSObject ,Mappable {
    
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
        
        var UserId : String?
        var Id : Int?
        
        var ReceiverName : String?
        var Address : String?
        var ContactTel : String?
        var Isdefault : Bool?
        var IsDeleted : Bool?
        var CityId : Int?
        var City : String?
        var Region : String?
        var StreetNo : String?
        var FloorNo : String?
        var Trademark : String?
        var isCheked = false
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            UserId<-map["UserId"]
            
            ReceiverName<-map["ReceiverName"]
            Address<-map["Address"]
            ContactTel<-map["ContactTel"]
            Isdefault<-map["Isdefault"]
            IsDeleted<-map["IsDeleted"]
            CityId<-map["CityId"]
            City<-map["City"]
            Region<-map["Region"]
            StreetNo<-map["StreetNo"]
            FloorNo<-map["FloorNo"]
            Trademark<-map["Trademark"]
        }
    }
}

