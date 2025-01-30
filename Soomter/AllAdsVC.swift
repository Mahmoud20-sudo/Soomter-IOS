//
//  AllAdsVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/28/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SideMenu
import Alamofire
import ObjectMapper

class AllAdsVC: ButtonBarPagerTabStripViewController {

    var isReload = false
    var adsData : AdsData.Result?
    
    var catId = 0
    var cityId = 0
    var typeId = 0
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    var child_1 : Child1VC?
    var child_2 : Child2VC?
    var child_3 : Child3VC?
    var child_4 : Child4VC?
    
    var selctedBarIndex : Int!
    
    @IBOutlet weak var settings_img: UIImageView!
    
    func navigateToSettingsScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher = UITapGestureRecognizer(
            
            target: self, action:  #selector (self.navigateToSettingsScreen(_:)))
        
        settings_img.addGestureRecognizer(gestureSwift2AndHigher)
        
//        menu_view.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] != "en"{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }else{
            menu_view.semanticContentAttribute = .forceRightToLeft
        }
        
        settings.style.buttonBarBackgroundColor = hexStringToUIColor(hex: "#FFDB92")
        settings.style.buttonBarItemBackgroundColor = hexStringToUIColor(hex: "#FFDB92")
        settings.style.buttonBarItemFont = UIFont(name: "SSTArabic-Roman", size: 12)!
        settings.style.selectedBarHeight = 0.5
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = hexStringToUIColor(hex: "#686868")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = hexStringToUIColor(hex: "#686868")
            newCell?.label.textColor = .black
        }
        
        if countData.isEmpty {
            getAdsStatistics()
        }
        else{
            prepareSideMenu()
        }
        
        super.viewDidLoad()
        self.scrollview.isScrollEnabled = true
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 800)
    }
    
    
    func changeTap(postion : Int){
        switch postion {
        case 0:
            navigationController?.popViewController(animated: true)
        case 1:
            moveTo(viewController: child_1!, animated: true)
        case 2:
            moveTo(viewController: child_2!, animated: true)
        case 3:
            moveTo(viewController: child_3!, animated: true)
        case 4:
            moveTo(viewController: child_4!
                , animated: true)
        default:
            print("LLL")
        }
        if Locale.preferredLanguages[0] != "en" {
            SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)
        }else{
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
         child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1") as! Child1VC
        child_1?.adsData = adsData
         child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2") as! Child2VC
        child_2?.adsData = adsData
         child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3")as! Child3VC
        child_3?.adsData = adsData
         child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child4")as! Child4VC
        child_4?.adsData = adsData
        pagerTabStripController.currentIndex = selctedBarIndex
        return [child_1!, child_2!, child_3!, child_4!]
    }
    
    
    func prepareSideMenu(){
        
        menu_btn.isEnabled = true
        // Define the menus
        //let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: ViewController())
        //menuLeftNavigationController.leftSide = true
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        //SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! ViewController
        
        menuVC.countData = countData
        menuVC.allAdsVC = self
        
        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
        if Locale.preferredLanguages[0] != "en" {
            SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
        }else{
            SideMenuManager.default.menuLeftNavigationController = menuRightNavigationController
        }

        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = self.view.frame.size.width - 100
        
    }

    @IBAction func menu_btn_clk(_ sender: UIButton) {
        if Locale.preferredLanguages[0] == "en" {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }else{
            present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        }

        
        // Similarly, to dismiss a menu programmatically, you would do this:
        //dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
 
    
    func getAdsStatistics(){
        let parameters: Parameters = [
            "AdsTo": 0
        ]
        
        Alamofire.request(ADS_COUNT_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
               // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
               // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                    //    print(json)
                        let adsStatData = Mapper<AdsStatData>().map(JSONObject: json)
                        
                        let home = Bundle.main.localizedString(forKey: "home-menu", value: nil, table: "Default")
                        let special = Bundle.main.localizedString(forKey: "special-ads", value: nil, table: "Default")
                        let video = Bundle.main.localizedString(forKey: "video-ads", value: nil, table: "Default")
                        let photo = Bundle.main.localizedString(forKey: "photo-ads", value: nil, table: "Default")
                        let text = Bundle.main.localizedString(forKey: "text-ads", value: nil, table: "Default")
                        //
                        let imagesList = ["Home-Icon.png" , "Special-Ads-Icon.png","pic-ads-Icon.png", "Video-Ads-Icon.png", "Text-Ads-Icon.png"]
                        let typeIdsList = [3, 4, 1]
                        
                        let keyLsit = [home , special, photo, video, text]
                        let countList = [adsStatData?.result?.AllAds ,
                                         adsStatData?.result?.StarAdsCount,adsStatData?.result?.ImageAdsCount ,adsStatData?.result?.VedioAdsCount,
                                         adsStatData?.result?.TextAdsCount]
                        
                        for i in 0 ..< 5 {
                            let obj = AdsStatisticsClass(_name: keyLsit[i], _img: imagesList[i]
                                , _count: countList[i]!)
                            countData.append(obj)
                        }
                        
                        self.prepareSideMenu()
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }


}
