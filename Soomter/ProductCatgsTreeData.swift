//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class ProductCatgsTreeData: NSObject ,Mappable {
    
    var status   : Int?
    var error     : String?
    var result    : [Result]?
    
    override init() {}
    
    required init?(map: Map) {
        print(map["Result"])
    }
    
    func mapping(map: Map) {
        
        error<-map["Error"]
        result<-map["Result"]
        status<-map["Status"]
    }
    
    class Result :NSObject , Mappable {
        
        var Name : String?
        var Image : String?
        var Id : Int?
        var Childs : [Childs]?
        
        required  init?(map: Map) {
             print(map[" print(json)"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Name<-map["Name"]
            Image<-map["Image"]
            Childs<-map["Childs"]
        }
    }
    
    class Childs :NSObject , Mappable {
        
        var Name : String?
        var Image : String?
        var Id : Int?
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Name<-map["Name"]
            Image<-map["Image"]
        }
    }

}

