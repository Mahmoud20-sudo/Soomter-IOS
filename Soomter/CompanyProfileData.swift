//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class CompanyProfileData: NSObject ,Mappable {
    
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
        var Id: Int?
        var CompanyBanchesCount: Int?
        var CompanyViewsCount: Int?
        var CompanyAdsCount: Int?
        var CompanyProductsCount: Int?
        var CompanyEventsCount: Int?
        var IsAppearInSite: Bool?
        var ShowMobileInDetails: Bool?
        var Address : String?
        var CompanyName : String?
        var CatgoryName : String?
        var FieldName : String?
        
        var Mobile : String?
        var AdsEmail : String?
        var Facebook : String?
        var Twitter : String?
        var CountryName : String?
        var Instagram : String?
        var YouTube : String?
        var linkedin : String?
        var GooglePlus : String?
        var Fax : String?
        
        var CategoryId : Int?
        var MessagesCount : Int?
        var UnifiedNumber : String?
        var CityName : String?
        var FieldId : Int?
        var RatingModel : RatingModel?
        var ListAds : [ListAds]?
        var ListEvents : [ListEvents]?
        var SimilarCompanies : [SimilarCompanies]?
        var BranchsCompany : [BranchsCompany]?
        var TextAdRequests : [TextAdRequests]?
        var ListProducts : [ListProducts]?
        var FreeNumber : String?
        var CommercialRegistrationNo : String?
        var Sunday_Thursday : String?
        var LogoId : String?
        
        var Ma3rofUrl : String?
        var MailBox : Int?
        var MaxRows : String?
        var Phone : String?
        var PostNumber : Int?
        var Summary : String?
        
        var TitleKey : String?
        var Trusted : Int?
        var ViewCounts : Int?
        var Website : String?
        var companyLogo : String?
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            CompanyBanchesCount<-map["CompanyBanchesCount"]
            CompanyViewsCount<-map["CompanyViewsCount"]
            CompanyAdsCount<-map["CompanyAdsCount"]
            CompanyProductsCount<-map["CompanyProductsCount"]
            CompanyEventsCount<-map["CompanyEventsCount"]
            IsAppearInSite<-map["IsAppearInSite"]
            
            ShowMobileInDetails<-map["ShowMobileInDetails"]
            Address<-map["Address"]
            CompanyName<-map["CompanyName"]
            
            CatgoryName<-map["CatgoryName"]
            FieldName<-map["FieldName"]
            
            Mobile<-map["Mobile"]
            AdsEmail<-map["AdsEmail"]
            Facebook<-map["Facebook"]
            
            Twitter<-map["Twitter"]
            CountryName<-map["CountryName"]
            Instagram<-map["Instagram"]
            
            YouTube<-map["YouTube"]
            linkedin<-map["linkedin"]
            GooglePlus<-map["GooglePlus"]
            
            Fax<-map["Fax"]
            CategoryId<-map["CategoryId"]
            MessagesCount<-map["MessagesCount"]
            
            UnifiedNumber<-map["UnifiedNumber"]
            MaxRows<-map["MaxRows"]
            Phone<-map["Phone"]
            
            CityName<-map["CityName"]
            FieldId<-map["FieldId"]
            TitleKey<-map["TitleKey"]
            Trusted<-map["Trusted"]
            ListAds<-map["ListAds"]
            Website<-map["Website"]
            ListAds<-map["ListAds"]
            ListEvents<-map["ListEvents"]
            SimilarCompanies<-map["SimilarCompanies"]
            BranchsCompany<-map["BranchsCompany"]
            TextAdRequests<-map["TextAdRequests"]
            ListProducts<-map["ListProducts"]
            CommercialRegistrationNo<-map["CommercialRegistrationNo"]
            Sunday_Thursday<-map["Sunday_Thursday"]

            LogoId<-map["LogoId"]
        }
    }
    
    class RatingModel :NSObject , Mappable {
        var Id : Int?
        var TotalRaters : Int?
        var Rating : Int?
        var AverageRating : Double?
        var RatingStarPercentage : Int?
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            TotalRaters<-map["TotalRaters"]
            Rating<-map["Rating"]
            AverageRating<-map["AverageRating"]
            RatingStarPercentage<-map["RatingStarPercentage"]
        }
    }
    
    class ListAds :NSObject , Mappable {
        var Id : Int?
        var CompanyId : Int?
        var Title : String?
        var CompanyName : String?
        var ImageId : Int?
        
        var FromDate : String?
        var IsPublished : Bool?
        var ToDate : String?
        var IsFavorite : Int?
        var IsIdentified : Bool?
        var IsIdentifieded : Int?
        
        var TitleKey : String?
        var Details : String?
        var AdsRequestStatusId : Int?
        var RequestTypeId : Int?
        var Status : String?
        var Url : String?
        var VedioUrl : String?
        var IsVedioAds : Bool?
        var CompanyTitleKey : String?
        var MaxRows : Int?
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            CompanyId<-map["CompanyId"]
            Title<-map["Title"]
            CompanyName<-map["CompanyName"]
            ImageId<-map["ImageId"]
            FromDate<-map["FromDate"]
            IsPublished<-map["IsPublished"]
            ToDate<-map["ToDate"]
            IsFavorite<-map["IsFavorite"]
            IsIdentified<-map["IsIdentified"]
            IsIdentifieded<-map["IsIdentifieded"]
            TitleKey<-map["TitleKey"]
            Details<-map["Details"]
            AdsRequestStatusId<-map["AdsRequestStatusId"]
            RequestTypeId<-map["RequestTypeId"]
            Status<-map["Status"]
            Url<-map["Url"]
            VedioUrl<-map["VedioUrl"]
            IsVedioAds<-map["IsVedioAds"]
            CompanyTitleKey<-map["CompanyTitleKey"]
            MaxRows<-map["MaxRows"]
        }
    }

    class ListEvents :NSObject , Mappable {
        var Id : Int?
        var SeqNum : Int?
        var Title : String?
        var CityName : String?
        var ImageId : Int?
        
        var BusinessCategory : String?
        var IsPublished : Bool?
        var EventType : String?
        var EventTypeId : Int?
        var IsStar : Bool?
        var IsFavorite : Bool?
        var AgentCompanyId : Int?
        
        var TitleKey : String?
        var Details : String?
        var IdentificationEndDate : String?
        var RequestTypeId : Int?
        var FromDate : String?
        var FromTime : String?
        var ToDate : String?
        var ToTime : String?
        var CompanyName : String?
        var CompanyTitleKey : String?
        var CompanyId : Int?
        var MaxRows : Int?
        var CreateDate : String?
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            SeqNum<-map["SeqNum"]
            Title<-map["Title"]
            CityName<-map["CityName"]
            ImageId<-map["ImageId"]
            BusinessCategory<-map["BusinessCategory"]
            IsPublished<-map["IsPublished"]
            EventType<-map["EventType"]
            IsFavorite<-map["IsFavorite"]
            IsStar<-map["IsStar"]
            EventTypeId<-map["EventTypeId"]
            TitleKey<-map["TitleKey"]
            Details<-map["Details"]
            AgentCompanyId<-map["AgentCompanyId"]
            RequestTypeId<-map["RequestTypeId"]
            IdentificationEndDate<-map["IdentificationEndDate"]
            FromDate<-map["FromDate"]
            FromTime<-map["FromTime"]
            ToDate<-map["ToDate"]
            ToTime<-map["ToTime"]
            CompanyName<-map["CompanyName"]
            CompanyTitleKey<-map["CompanyTitleKey"]
            CompanyId<-map["CompanyId"]
            CreateDate<-map["CreateDate"]
            MaxRows<-map["MaxRows"]
        }
    }
    
    class SimilarCompanies :NSObject , Mappable {
        var CompanyId : Int?
        var CompanyName : String?
        var Summary : String?
        var LogoId : Int?
        var IsIdentified : Bool?
        var Rating : Int?
        var TitleKey : String?
        var TotalRaters : Int?
       
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            CompanyId<-map["CompanyId"]
            CompanyName<-map["CompanyName"]
            Summary<-map["Summary"]
            LogoId<-map["LogoId"]
            IsIdentified<-map["IsIdentified"]
            Rating<-map["Rating"]
            TitleKey<-map["TitleKey"]
            TotalRaters<-map["TotalRaters"]
        }
    }

    class ListProducts :NSObject , Mappable {
        var Id : Int?
        var Title : String?
        var Details : String?
        var TradeMark : String?
        var PublishDate : String?
        var ImageId : Int?
        var Image : String?
        var ExtraOffer : Int?
        
        var Discount : Double?
        var ProductTo : Int?
        var Price : Int?
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
        var CanOrder : Bool?
        var FromProflile : Int?
        var TitleKey : String?
        var ProductTitleKey : String?
        var MaxRows : Int?
        
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            Title<-map["Title"]
            Details<-map["Details"]
            TradeMark<-map["TradeMark"]
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
            Rate<-map["Rate"]
            ProductFieldValueId<-map["ProductFieldValueId"]
            Filter<-map["Filter"]
            SaleCount<-map["SaleCount"]
            CompanyName<-map["CompanyName"]
            CompanyId<-map["CompanyId"]
            CanOrder<-map["CanOrder"]
            FromProflile<-map["FromProflile"]
            TitleKey<-map["TitleKey"]
            ProductTitleKey<-map["ProductTitleKey"]
            MaxRows<-map["MaxRows"]
        }
    }
    
    class BranchsCompany :NSObject , Mappable {
        var Id : Int?
        var CompanyId : Int?
        var BranchAddress : String?
        var BranchPhone : String?
        var BranchFax : String?
        var BranchMobile : String?
        var Saturday : String?
        var Sunday_Thursday : String?
        
        var Friday : String?
        var Latitude : String?
        var Longitude : String?
        var CityName : String?
        var CountyId : Int?
        
        var CityKey : String?
        var FromDay : String?
        var ToDay : String?
        var FromTimeFirstSheft : Int?
        var ToTimeFirstSheft : Int?
        var FromTimesecondSheft : Int?
        var ToTimesecondSheft : Int?
        var BranchName : String?
        
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            Id<-map["Id"]
            CompanyId<-map["CompanyId"]
            BranchAddress<-map["BranchAddress"]
            BranchPhone<-map["BranchPhone"]
            BranchFax<-map["BranchFax"]
            BranchMobile<-map["BranchMobile"]
            Saturday<-map["Saturday"]
            Sunday_Thursday<-map["Sunday_Thursday"]
            
            Friday<-map["Friday"]
            Latitude<-map["Latitude"]
            Longitude<-map["Longitude"]
            CityName<-map["CityName"]
            CountyId<-map["CountyId"]
            CityKey<-map["CityKey"]
            FromDay<-map["FromDay"]
            FromTimeFirstSheft<-map["FromTimeFirstSheft"]
            ToDay<-map["ToDay"]
            ToTimeFirstSheft<-map["ToTimeFirstSheft"]
            FromTimesecondSheft<-map["FromTimesecondSheft"]
            ToTimesecondSheft<-map["ToTimesecondSheft"]
            BranchName<-map["BranchName"]
        }
    }

    class TextAdRequests :NSObject , Mappable {
        var CompanyId : Int?
        var CompanyName : String?
        var Summary : String?
        var LogoId : Int?
        var IsIdentified : Bool?
        var Rating : Int?
        var TitleKey : String?
        var TotalRaters : Int?
        
        
        required  init?(map: Map) {
            // print(map["Email"])
        }
        
        func mapping(map: Map) {
            CompanyId<-map["CompanyId"]
            CompanyName<-map["CompanyName"]
            Summary<-map["Summary"]
            LogoId<-map["LogoId"]
            IsIdentified<-map["IsIdentified"]
            Rating<-map["Rating"]
            TitleKey<-map["TitleKey"]
            TotalRaters<-map["TotalRaters"]
        }
    }

}

