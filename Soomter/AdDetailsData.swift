//
//  Ads.swift
//  Soomter
//
//  Created by Mahmoud on 8/29/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class AdDetailsData: NSObject ,Mappable {
    
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
        var CompanyName : String?
        var EnCompanyName : String?
        
        var CityName : String?
        var FromDate : String?
        var ToDate : String?
        var ImageId : String?
        var Image : String?
        var Details : String?
        var CategoryId : Int?
        var Url : String?
        var Title : String?
        var IsFavorite : Int?
        var CategoryName : String?
        var Phone : String?
        var PhoneKey : String?
        var Mobile : String?
        var SubCategoryName : String?
        var CompanyId : Int?
        var CurrentCompanyId : Int?
        var AdsCatigoryId : Int?
        var AdsCatigoryName : String?

        var TitleKey : String?
        var ListSemilarAds : [SimilarAds]?
        var IsIdentified : Bool?
        var IsVedioAds : Bool?
        var VedioUrl : String?
        var CityList : String?
        var ListBusinessCategoriesViewModel : String?
        
        
        required  init?(map: Map) {
            //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            CompanyName<-map["CompanyName"]
            EnCompanyName<-map["EnCompanyName"]
            CityName<-map["CityName"]
            FromDate<-map["FromDate"]
            ToDate<-map["ToDate"]
            ImageId<-map["ImageId"]
            Image<-map["Image"]
            Details<-map["Details"]
            CategoryId<-map["CategoryId"]
            Url<-map["Url"]
            Title<-map["Title"]
            IsFavorite<-map["IsFavorite"]
            CategoryName<-map["CategoryName"]
            Phone<-map["Phone"]
            PhoneKey<-map["PhoneKey"]
            Mobile<-map["Mobile"]
            SubCategoryName<-map["SubCategoryName"]
            CompanyId<-map["CompanyId"]
            CurrentCompanyId<-map["CurrentCompanyId"]
            AdsCatigoryId<-map["AdsCatigoryId"]
            AdsCatigoryName<-map["AdsCatigoryName"]
            TitleKey<-map["TitleKey"]
            
            IsIdentified<-map["IsIdentified"]
            IsVedioAds<-map["IsVedioAds"]
            VedioUrl<-map["VedioUrl"]
            CityList<-map["CityList"]
            ListSemilarAds<-map["ListSemilarAds"]
            ListBusinessCategoriesViewModel<-map["ListBusinessCategoriesViewModel"]
    
        }
        
        class SimilarAds :NSObject , Mappable {
            
            var id : Int?
            var Title : String?
            var CompanyId : Int?
            var TitleKey : String?
            
            var FromDate : String?
            var ToDate : String?
            
            var IsFavorite : Int?
            var IsPublished : Int?
        
            var AdsRequestStatusId : Int?
        
            var AdsRequestStatus : String?
            var Details : String?

            var CompanyName : String?
            var CompanyTitleKey : String?
        
            var Url : String?
            var VedioUrl : String?
            var IsIdentified : Int?
            var IsVedioAds : Bool?
            var type : Int?
            var ImageId : Int?
            var Image : String?
            var MaxRows : Int?
            
            required  init?(map: Map) {
                //  print(map["Id"])
            }
            
            func mapping(map: Map) {
                id<-map["Id"]
                Title<-map["Title"]
                CompanyId<-map["CompanyId"]
                CompanyName<-map["CompanyName"]
                IsFavorite<-map["IsFavorite"]
                IsVedioAds<-map["IsVedioAds"]
                AdsRequestStatusId<-map["AdsRequestStatusId"]
                IsPublished<-map["IsPublished"]
                IsPublished<-map["IsPublished"]
                Details<-map["Details"]
                AdsRequestStatus<-map["AdsRequestStatus"]
                Url<-map["Url"]
                FromDate<-map["FromDate"]
                ToDate<-map["ToDate"]
                TitleKey<-map["TitleKey"]
                IsIdentified<-map["IsIdentified"]
                type<-map["Type"]
                ImageId<-map["ImageId"]
                Image<-map["Image"]
                CompanyTitleKey<-map["CompanyTitleKey"]
                MaxRows<-map["MaxRows"]
            }
        }
    }
}
