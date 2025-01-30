//
//  EventDetailsData.swift
//  Soomter
//
//  Created by Mahmoud on 9/1/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class EventDetailsData: NSObject ,Mappable {
    
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
        
        var Id : Int?
        var HigriToDate : String?
        var HigriFromDate : String?
        var timeFrom : String?
        var timeTo : String?
        
        var DateFrom : String?
        var DateTo : String?
        var Time : String?
        var Location : String?
        var BusinessCategory : String?
        var Status : Int?
        var Mobile : String?
        var Telephone : String?
        var Email : String?
        var EventUrl : String?
        var Long : String?
        var Lat : String?
        var Title : String?
        var EventStatus : Int?
        var Organizers : [Organizers]?
        var Image : String?
        var Category : String?
        var Link : String?
        var Details : String?
        
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            HigriToDate<-map["HigriToDate"]
            HigriFromDate<-map["HigriFromDate"]
            timeFrom<-map["timeFrom"]
            
            DateFrom<-map["DateFrom"]
            DateTo<-map["DateTo"]
            Time<-map["Time"]
            BusinessCategory<-map["BusinessCategory"]
            Status<-map["Status"]
            Mobile<-map["Mobile"]
            Email<-map["Email"]
            EventUrl<-map["EventUrl"]
            Long<-map["Long"]
            
            Lat<-map["Lat"]
            Title<-map["Title"]
            EventStatus<-map["EventStatus"]
            Organizers<-map["Organizers"]
            Image<-map["Image"]
            Category<-map["Category"]
            Link<-map["Link"]
            Details<-map["Details"]
        }
    }
    
    class Organizers :NSObject , Mappable {
        
        var id : Int?
        var CompanyName : String?
        var TitleKey : String?
        var Summary : String?
        var ImageId : Int?
        var Image : String?
        
        required  init?(map: Map) {
            //  print(map["Id"])
        }
        
        func mapping(map: Map) {
            id<-map["Id"]
            CompanyName<-map["CompanyName"]
            TitleKey<-map["TitleKey"]
            ImageId<-map["ImageId"]
            Image<-map["Image"]
        }
    }
    
}
