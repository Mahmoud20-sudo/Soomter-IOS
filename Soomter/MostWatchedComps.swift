//
//  User.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
import ObjectMapper

class MostWatchedComps: NSObject ,Mappable {
    
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
        var Address : String?
        var Advertising : String?
        var AdvertisingEndDate : String?
    
    var AdvertisingStartDate : String?
    var AverageRating : Double?
    var CityName : String?
    var CompanyEmail : String?
    var CompanyName : String?
    var CompanyUserId : String?
    var CountADS : Int?
    var CountEvents : Int?
    var CountProduct : Int?
    var CountryName : String?
    var EndHighlightDate : String?
    
    var FeaturedCompany : Int?
    var FieldId : Int?
    var FreeNumber : Int?
    var IsAdminAdd : String?
    var IsFlowed : Int?
    
    
    var IsIdentefied : Int?
    var Key : Int?
    var LastLoginDate : String?
    var Logo : String?
    var LogoId : Int?
    
    var Ma3rofUrl : String?
    var MailBox : Int?
    var MaxRows : String?
    var Phone : String?
    var PostNumber : Int?
    var Summary : String?
    
    
    var TitleKey : String?
    var TotalRaters : Int?
    var Trusted : Int?
    var ViewCounts : Int?
    var Website : String?
    var companyLogo : String?
    
        var id : Int?
        
        required  init?(map: Map) {
           // print(map["Email"])
        }
        
        func mapping(map: Map) {
            id<-map["Id"]
            Address<-map["Address"]
            Advertising<-map["Advertising"]
            AdvertisingEndDate<-map["AdvertisingEndDate"]
            AdvertisingStartDate<-map["AdvertisingStartDate"]
            AverageRating<-map["AverageRating"]
            CityName<-map["CityName"]
            
            CompanyEmail<-map["CompanyEmail"]
            CompanyName<-map["CompanyName"]
            CompanyUserId<-map["CompanyUserId"]
            
            CountADS<-map["CountADS"]
            CountEvents<-map["CountEvents"]
            CountProduct<-map["CountProduct"]
            
            CountryName<-map["CountryName"]
            EndHighlightDate<-map["EndHighlightDate"]
            FeaturedCompany<-map["FeaturedCompany"]
            
            FieldId<-map["FieldId"]
            FreeNumber<-map["FreeNumber"]
            IsAdminAdd<-map["IsAdminAdd"]
            
            IsFlowed<-map["IsFlowed"]
            Key<-map["Key"]
            LastLoginDate<-map["LastLoginDate"]
            
            Logo<-map["Logo"]
            LogoId<-map["LogoId"]
            Ma3rofUrl<-map["Ma3rofUrl"]
            
            MailBox<-map["MailBox"]
            MaxRows<-map["MaxRows"]
            Phone<-map["Phone"]
            
            PostNumber<-map["PostNumber"]
            Summary<-map["Summary"]
            TitleKey<-map["TitleKey"]
            TotalRaters<-map["TotalRaters"]
            Trusted<-map["Trusted"]
            ViewCounts<-map["ViewCounts"]
            Website<-map["Website"]
            companyLogo<-map["companyLogo"]

        }
    }
}

