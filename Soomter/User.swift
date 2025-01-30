//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class User: NSObject ,Mappable {
    
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
        
        var name : String?
        var email : String?
        var userType : String?
        var id : String?
        var relatedId : Int?
        
        required  init?(map: Map) {
           // print(map["Email"])
        }
        
        func mapping(map: Map) {
            email<-map["Email"]
            id<-map["Id"]
            name<-map["Name"]
            relatedId<-map["RelatedId"]
            userType<-map["UserType"]
        }
    }
}

