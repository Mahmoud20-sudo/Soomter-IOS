//
//  AdsStatData.swift
//  Soomter
//
//  Created by Mahmoud on 8/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import Foundation

import ObjectMapper

class AdsStatData: NSObject ,Mappable {
    
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
        
        var AllAds : Int?
        var ImageAdsCount : Int?
        var StarAdsCount : Int?
        var TextAdsCount : Int?
        var VedioAdsCount : Int?
        
        required  init?(map: Map) {
          //  print(map["PromotedAds"])
        }
        
        func mapping(map: Map) {
            AllAds<-map["AllAds"]
            ImageAdsCount<-map["ImageAdsCount"]
            StarAdsCount<-map["StarAdsCount"]
            TextAdsCount<-map["TextAdsCount"]
            VedioAdsCount<-map["VedioAdsCount"]
        }
    }
    
    
}
