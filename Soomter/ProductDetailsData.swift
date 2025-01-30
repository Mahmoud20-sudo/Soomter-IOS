//
//  BestProductsData.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class ProductDetailsData: NSObject ,Mappable {
    
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
        var Title : String?
        var Description : String?
        
        var FreeShipping : Bool?
        var ImageId : Int?
        var Image : String?
        var IncludesValueAddedstring : String?
        var TradeMark : String?
        var ShippingCityId : String?
        var Price : Int?
        var PriceAfterDis : Int?
        var Discount : Int?
        var IdentificationEndDate : String?
        var ProductTo : Int?
        var CompanyId : Int?
        
        var ProductFieldValueId : Int?
        var ShippingDate : String?
        var Details : String?
        var CompanyName : String?
        var CatigoryId : Int?
        
        var ProductsProperties : [ProductsProperties]?
        var ImageList : [ImageList]?
        var ListSelectedProducts : [ListSelectedProducts]?
        var TitleKey : String?
        var listRating : [ListRating]?
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Details<-map["Details"]
            Description<-map["Description"]
            ImageId<-map["ImageId"]
            Image<-map["Image"]
            FreeShipping<-map["FreeShipping"]
            Discount<-map["Discount"]
            ProductTo<-map["ProductTo"]
            Price<-map["Price"]
            IncludesValueAddedstring<-map["IncludesValueAddedstring"]
            TradeMark<-map["TradeMark"]
            IdentificationEndDate<-map["IdentificationEndDate"]
            ShippingCityId<-map["ShippingCityId"]
            PriceAfterDis<-map["PriceAfterDis"]
            ProductFieldValueId<-map["ProductFieldValueId"]
            IdentificationEndDate<-map["IdentificationEndDate"]
            CompanyName<-map["CompanyName"]
            CompanyId<-map["CompanyId"]
            ShippingDate<-map["ShippingDate"]
            CatigoryId<-map["CatigoryId"]
            TitleKey<-map["TitleKey"]
            Image<-map["Image"]
            ProductsProperties<-map["ProductsProperties"]
            ImageList<-map["ImageList"]
            ListSelectedProducts<-map["ListSelectedProducts"]
            listRating<-map["listRating"]
         }
    }
    
    class ListSelectedProducts :NSObject , Mappable {
        
        var Id : Int?
        var Title : String?
        var Details : String?
        
        var PublishDate : String?
        var ImageId : Int?
        var Image : String?
        var ExtraOffer : String?
        var Discount : Double?
        var ProductTo : String?
        var Price : Int?
        var Rating : Int?
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
    
    class ImageList :NSObject , Mappable {
        var Id : Int?
        var Title : String?
        var Order : Int?
        var Image : String?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Order<-map["Order"]
            Image<-map["Image"]
        }
    }
    
    class ListRating :NSObject , Mappable {
        
        var Id : Int?
        var Name : String?
        var RatingDate : String?
        
        var RateText : String?
        var ProductId : Int?
        var UserId : String?
        var TitleKey : String?
        var Rating : Double?
        var Comment : String?
        var CompanyId : Int?
        var TotalRaters : Int?
        var Rate : String?
        var Advantages : String?
        var DisAdvantages : String?
        var Title : String?
        
        var listRating : String?
        var RatingModel : String?
        var MaxRows : Int?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Name<-map["Name"]
            RateText<-map["RateText"]
            UserId<-map["UserId"]
            ProductId<-map["ProductId"]
            TitleKey<-map["TitleKey"]
            Rating<-map["Rating"]
            Comment<-map["Comment"]
            CompanyId<-map["CompanyId"]
            Rating<-map["Rating"]
            TotalRaters<-map["TotalRaters"]
            Advantages<-map["Advantages"]
            Rate<-map["Rate"]
            DisAdvantages<-map["DisAdvantages"]
            listRating<-map["listRating"]
            RatingModel<-map["RatingModel"]
            CompanyId<-map["CompanyId"]
            MaxRows<-map["MaxRows"]
        }
    }
    
    class ProductsProperties :NSObject , Mappable {
        var Disabled : Bool?
        var Group : String?
        var Text : String?
        var Value : String?
        var Selected : Bool?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Disabled<-map["Disabled"]
            Group<-map["Group"]
            Text<-map["Text"]
            Value<-map["Value"]
            Selected<-map["Selected"]
        }
    }


    
}
