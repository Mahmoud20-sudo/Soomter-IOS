//
//  BestProductsData.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class BestProductsData: NSObject ,Mappable {
    
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
        
        var Id : Int?
        var Title : String?
        var Details : String?
        
        var PublishDate : String?
        var ImageId : Int?
        var Image : String?
        var ExtraOffer : String?
        var Discount : Double?
        var ProductTo : String?
        var Price : Double?
        var Rating : Double?
        var TotalRaters : Int?
        var IdentificationEndDate : String?
        var IsFavorite : Int?
        var Rate : Int?
    
        var ProductFieldValueId : Int?
        var Filter : Int?
        var SaleCount : Int?
        var CompanyName : String?
        var CompanyId : Int?
        var CanOrder : Int?
    
        var FromProflile : Int?
        var TitleKey : String?
        var ProductTitleKey : String?
        var MaxRows : Int?
    
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Details<-map["Details"]
            PublishDate<-map["PublishDate"]
            ImageId<-map["ImageId"]
            Image<-map["Image"]
            ExtraOffer<-map["ExtraOffer"]
            Discount<-map["Discount"]
            ProductTo<-map["ProductTo"]
            Price<-map["Price"]
            Rating<-map["Rating"]
            TotalRaters<-map["TotalRaters"]
            IdentificationEndDate<-map["IdentificationEndDate"]
            IsFavorite<-map["IsFavorite"]
            Rate<-map["Rate"]
            ProductFieldValueId<-map["ProductFieldValueId"]
            Filter<-map["Filter"]
            CompanyName<-map["CompanyName"]
            CompanyId<-map["CompanyId"]
            SaleCount<-map["SaleCount"]
            FromProflile<-map["FromProflile"]
            TitleKey<-map["TitleKey"]
            Image<-map["Image"]
            ProductTitleKey<-map["ProductTitleKey"]
            MaxRows<-map["MaxRows"]
        }
    }
}
