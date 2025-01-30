//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class CitiesData: NSObject ,Mappable {
    
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
        
        var name : String?
        var id : Int?
        var isCheked = false
        
        init(name : String, id: Int, isChekced : Bool) {
            self.name = name
            self.id = id
            self.isCheked = isChekced
        }
        
        required  init?(map: Map) {
           // print(map["Email"])
        }
        
        func mapping(map: Map) {
            id<-map["Id"]
            name<-map["Name"]
        }
    }
}

