//
//  BestProductsData.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class CartData: NSObject ,Mappable {
    
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
        
        var Items : [Items]?
        var ShippingInfo : ShippingInfo?
        var ShippingCity : String?
        
        var DeliverDate : String?
        var CashOnDeliveryFees : Int?
        var ShippingExpenses : Int?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Items<-map["Items"]
            ShippingInfo<-map["ShippingInfo"]
            ShippingCity<-map["ShippingCity"]
            DeliverDate<-map["DeliverDate"]
            CashOnDeliveryFees<-map["CashOnDeliveryFees"]
            ShippingExpenses<-map["ShippingExpenses"]
           
        }
    }
    
    class ShippingInfo :NSObject , Mappable {
        
        var Id : Int?
        var UserId : String?
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
        
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
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
    
    class Items :NSObject , Mappable {
        
        var QuantityList : [QuantityList]?
        var FreeShipping : Bool?
        var IncludesVat : Bool?
        
        var IsProductAvailable : Bool?
        var CashOnDeliveryFees : Int?
        var Id : Int?
        var ProductId : Int?
        var ProductFieldValueId : Int?
        var Title : String?
        var CompanyId : Int?
        var ProductImageId : Int?
        var Details : String?
        var TradeMark : String?
        var CompanyName : String?
        var ItemQuantity : Int?
        var ImageId : Int?
        var TitleKey : String?
        var ProductTitleKey : String?
        var PriceWithoutDiscount : Double?
        var Price : Double?
        var Discount : Double?
        var VatValue : Double?
        var FieldValues : String?
        var FieldValueParentId : Int?
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            QuantityList<-map["QuantityList"]
            FreeShipping<-map["FreeShipping"]
            IncludesVat<-map["IncludesVat"]
            IsProductAvailable<-map["IsProductAvailable"]
            CashOnDeliveryFees<-map["CashOnDeliveryFees"]
            Id<-map["Id"]
            ProductId<-map["ProductId"]
            ProductFieldValueId<-map["ProductFieldValueId"]
            Title<-map["Title"]
            CompanyId<-map["CompanyId"]
            ProductImageId<-map["ProductImageId"]
            Details<-map["Details"]
            TradeMark<-map["TradeMark"]
            CompanyName<-map["CompanyName"]
            ItemQuantity<-map["ItemQuantity"]
            ImageId<-map["ImageId"]
            TitleKey<-map["TitleKey"]
            PriceWithoutDiscount<-map["PriceWithoutDiscount"]
            Price<-map["Price"]
            Discount<-map["Discount"]
            VatValue<-map["VatValue"]
            FieldValues<-map["FieldValues"]
            FieldValueParentId<-map["FieldValueParentId"]
        }
    }
    
    class QuantityList :NSObject , Mappable {
            
            var Id : String?
            
            var Name : String?
            var IdString : Int?
            
            required  init?(map: Map) {
                //  print(map["PromotedAds"])
            }
            
            func mapping(map: Map) {
                IdString<-map["IdString"]
                Name<-map["Name"]
                Id<-map["Id"]
                
            }
        }
    }

