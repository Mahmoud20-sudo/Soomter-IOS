//
//  Contstants.swift
//  Soomter
//
//  Created by Mahmoud on 7/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AVFoundation
import ESTabBarController_swift


func getRightUrl(inputID: String) -> String {
    var videoId = ""
    if (inputID.contains("be/")) {
        videoId = (inputID.components(separatedBy: "be/")[1])
    } else{
        videoId = (inputID.components(separatedBy: "v=")[1])
    }
    
    if (videoId.contains("?t")){
        videoId = videoId.components(separatedBy: "\\?t")[0]
    }
    //
    if (videoId.contains("&t")){
        videoId = videoId.components(separatedBy: "&t5")[0]
    }
    if (videoId.contains("&")){
        videoId = videoId.components(separatedBy: "&")[0]
        
    }
    
    return "https://img.youtube.com/vi/" + videoId + "/hqdefault.jpg"
}

typealias CompletionHandler = (_ success:Bool) -> Void

typealias CompletionHandler2 = (_ content:BestProductsData) -> Void

var countData = [AdsStatisticsClass]()

var eventcountsData : [EventCountsData.Result] = []

let BASIC_URL = "http://mobile.soomter.com"
let LOGIN_URL = BASIC_URL + "/api/LoginSoomter/"
let REG_COMP_URL = BASIC_URL + "/api/RegisterCompany/"
let PERSON_COMP_URL = BASIC_URL + "/api/RegisterProfile/"
let MOST_WATCHED_COMPANIES_URL = BASIC_URL + "/api/GetMostWatchedCompanies/"
let FOLLOW_COMPANY_URL = BASIC_URL + "/api/FlowCompany/"
let UNFOLLOW_COMPANY_URL = BASIC_URL + "/api/UnFlowCompany/"
let PORTAL_BUSSINES_CATGS_URL = BASIC_URL + "/api/GetPortalBusinessCategories/"

let CITIES_URL = BASIC_URL + "/api/GetAllCities/"
let BUSSINES_CATGS_URL = BASIC_URL + "/api/GetSubBusinessCategories/"
let COMPANIES_URL = BASIC_URL + "/api/GetCompaniesByCategories/"
//Search
let COMPANIES_SEARCH_URL = BASIC_URL + "/api/Search/"
//CompanyProfile
let COMPANIES_PROFILE_URL = BASIC_URL + "/api/CompanyProfile/"
//FlowCompany
let FOLLOW_COMP_URL = BASIC_URL + "/api/FlowCompany/"

//GetSoomterAds
let ADS_URL = BASIC_URL + "/api/GetSoomterAds/"
//GetSoomterAdsStatistics
let ADS_COUNT_URL = BASIC_URL + "/api/GetSoomterAdsStatistics/"

let AD_DETAILS_URL = BASIC_URL + "/api/GetAdsDetails/"
//GETEVENTSBYID
let EVENTS_URL = BASIC_URL + "/api/GetEvents/"
let EVENTS_COUNTS_URL = BASIC_URL + "/api/GetEventsCount/"
let EVENTS_DETAILS_URL = BASIC_URL + "/api/GETEVENTSBYID/"

//GetBestSellingProducts GetProductCategoriesTree
let BEST_SELLING_PRODUCTS_URL = BASIC_URL + "/api/GetBestSellingProducts/"

let GET_PRODUCTS_URL = BASIC_URL + "/api/GetProducts/"
let BEST_TRADEMARKS_URL = BASIC_URL + "/api/GetBestTradeMarks/"
let BEST_CATGS_URL = BASIC_URL + "/api/GetBestCategories/"
let PRODUCT_DETAILS_URL = BASIC_URL + "/api/GetProductDetails/"
let PRODUCT_CATGS_URL = BASIC_URL + "/api/GetProductCategoriesTree/"
//ALLNOTIFICATIONS
let NOTIFICATIONS_URL = BASIC_URL + "/api/ALLNOTIFICATIONS/"
let TOP_DOWN_ADS = BASIC_URL + "/api/GetTopDownAds/"
let SEND_GENERAL_COMPANY = BASIC_URL + "/api/SendGeneralCompanyRequest"
let ADD_TO_CART_URL = BASIC_URL + "/api/ADDTOCART/"
let ADD_ADDRESS_URL = BASIC_URL + "/api/ADDSHIPPINGADDRESSES/"
let GET_ADDRESS_URL = BASIC_URL + "/api/GETSHIPPINGADDRESSES/"
let PROCESS_CART_URL = BASIC_URL + "/api/PROCESSCART/"
let LOAD_CART_URL = BASIC_URL + "/api/LOADCART/"
let REMOVE_FROM_CART = BASIC_URL + "/api/REMOVEFROMCART/"
let FAV_PRODUCT_URL = BASIC_URL + "/api/ADDFAVPRODUCT/"

let UNFAV_PRODUCT_URL = BASIC_URL + "/api/ADDFAVPRODUCT/"

let FORGOT_PASS_URL = BASIC_URL + "/api/RETRIVEACCOUNT/"

let DELETE_ALL_NOTIFS_URL = BASIC_URL + "/api/DeleteAllNotifications"

func validateEmail(enteredEmail:String) -> Bool {
    
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
    
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
func hexStringToUIColor (hex:String , alpha: Float) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}

func displayToastMessage(_ message : String) {
    
    let toastView = UILabel()
    toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    toastView.textColor = UIColor.white
    toastView.textAlignment = .center
    toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
    toastView.layer.cornerRadius = 25
    toastView.layer.masksToBounds = true
    toastView.text = message
    toastView.numberOfLines = 0
    toastView.alpha = 0
    toastView.translatesAutoresizingMaskIntoConstraints = false
    
    let window = UIApplication.shared.delegate?.window!
    window?.addSubview(toastView)
    
    let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
    
    let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
    
    let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
    
    NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
    NSLayoutConstraint.activate(verticalContraint)
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
        toastView.alpha = 1
    }, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 0
        }, completion: { finished in
            toastView.removeFromSuperview()
        })
    })
}
func setBottomBorder(field : UITextField){
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = hexStringToUIColor(hex: "#E1C79B").cgColor
    border.frame = CGRect(x: 0, y: field.frame.size.height - width, width: field.frame.size.width + 50, height: field.frame.size.height)
    
    border.borderWidth = width
    field.layer.addSublayer(border)
    field.layer.masksToBounds = true
}
func getPortalBussCatgs(completionHandler: @escaping CompletionHandler){
    let parameters: Parameters = [
        "Lang": Locale.preferredLanguages[0]
    ]
    
    Alamofire.request(PORTAL_BUSSINES_CATGS_URL , method : .post, parameters :
        parameters , encoding: JSONEncoding.default).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            switch response.result{
            case .success:
                if let json = response.result.value {
                    //print(json)
                    let portalBussinsCatgsData = Mapper<PortalBussinsCatgsData>().map(JSONObject: json)
                    if portalBussinsCatgsData?.result != nil {
                      let myData = NSKeyedArchiver.archivedData(withRootObject: json)
                      UserDefaults.standard.set(myData, forKey: "PortalBussinsCatgsData")
                      completionHandler(true)
                   }
                }
                break
            case .failure(let error):
                completionHandler(false)

                break
            }
    }
}
func getCities(completionHandler: @escaping CompletionHandler){
    let parameters: Parameters = [
        "Lang": Locale.preferredLanguages[0]
    ]
    
    Alamofire.request(CITIES_URL , method : .post, parameters :
        parameters , encoding: JSONEncoding.default).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            switch response.result{
            case .success:
                if let json = response.result.value {
                   // print(json)
                    let portalBussinsCatgsData = Mapper<CitiesData>().map(JSONObject: json)
                    if portalBussinsCatgsData?.result != nil {
                        let myData = NSKeyedArchiver.archivedData(withRootObject: json)
                        UserDefaults.standard.set(myData, forKey: "CITIES")
                        completionHandler(true)
                    }
                }
                break
            case .failure(let error):
                completionHandler(false)
                
                break
            }
    }
}
func getProdsCatgsTree(completionHandler: @escaping CompletionHandler){
    let parameters: Parameters = [
        "lang": Locale.preferredLanguages[0]
    ]
    
    Alamofire.request(PRODUCT_CATGS_URL , method : .post, parameters :
        parameters , encoding: JSONEncoding.default).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            switch response.result{
            case .success:
                if let json = response.result.value {
                    //print(json)
                    let portalBussinsCatgsData = Mapper<ProductCatgsTreeData>().map(JSONObject: json)
                    if portalBussinsCatgsData?.result != nil {
                        let myData = NSKeyedArchiver.archivedData(withRootObject: json)
                        UserDefaults.standard.set(myData, forKey: "PRODS_CATGS")
                        completionHandler(true)
                    }
                }
                break
            case .failure(let error):
                completionHandler(false)
                
                break
            }
    }
}




