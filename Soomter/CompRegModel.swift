//
//  CompRegModel.swift
//  Soomter
//
//  Created by Mahmoud on 8/2/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import ObjectMapper

class CompRegModel: NSObject ,Mappable {
    
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
        
        var UserId : String?
        var Message : String?
        
        required  init?(map: Map) {
            //print(map["Email"])
        }
        
        func mapping(map: Map) {
            UserId<-map["UserId"]
            Message<-map["Message"]
        }
    }
}
