//
//  MainAdsVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/26/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SideMenu

class MainAdsVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var search_container: UIView!
    @IBOutlet weak var serch_img: UIImageView!
    @IBOutlet weak var options_img: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var special_ads_cv: UICollectionView!
    @IBOutlet weak var photo_ads_cv: UICollectionView!
    @IBOutlet weak var video_ads_cv: UICollectionView!
    @IBOutlet weak var text_ads_cv: UICollectionView!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    @IBOutlet weak var adImg: UIImageView!
    
    @IBOutlet weak var menu_btn: UIButton!
    
    @IBOutlet weak var secondPV: MSProgressView!
    @IBOutlet weak var thirdPV: MSProgressView!
    @IBOutlet weak var fourthPV: MSProgressView!
    
    
    @IBOutlet weak var starads_btn: UIButton!
    @IBOutlet weak var photoads_btn: UIButton!
    @IBOutlet weak var videoads_btn: UIButton!
    @IBOutlet weak var textads_btn: UIButton!
    
    @IBOutlet fileprivate weak var presentModeSegmentedControl:UISegmentedControl!
    
    let aaa = ["aaa","asdasda"]
    var specialAdsList : [AdsData.AdsClass] = []
    var photoAdsList : [AdsData.AdsClass] = []
    var videoAdsList : [AdsData.AdsClass] = []
    var textAdsList : [AdsData.AdsClass] = []
    
    var selctedBarIndex : Int!
    
    @IBOutlet weak var first_View: UIView!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var second_View: UIView!
    @IBOutlet weak var third_View: UIView!
    @IBOutlet weak var fourth_View: UIView!
    @IBOutlet weak var firstPV: MSProgressView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var catId = 0
    var cityId = 0
    var typeId = 0
    
    var adsData : AdsData.Result?
    
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

        
        options_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToSearchScreen(_:)))
        options_img.addGestureRecognizer(gestureSwift2AndHigher2)
        
        searchTF.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        searchTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        
        search_container.roundedWithBorder(radius: 15)
        // Do any additional setup after loading the view.
        options_img.image = options_img.image!.withRenderingMode(.alwaysTemplate)
        options_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        serch_img.image = serch_img.image!.withRenderingMode(.alwaysTemplate)
        serch_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        // Do any additional setup after loading the view.
        
        if Locale.preferredLanguages[0] != "en"{
            serch_img.transform = serch_img.transform.rotated(by: CGFloat(Double.pi / 2))
                       bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            menu_view.semanticContentAttribute = .forceLeftToRight
            first_View.semanticContentAttribute = .forceLeftToRight
            second_View.semanticContentAttribute = .forceLeftToRight
            third_View.semanticContentAttribute = .forceLeftToRight
            fourth_View.semanticContentAttribute = .forceLeftToRight
        }
        else{
             menu_view.semanticContentAttribute = .forceRightToLeft
            first_View.semanticContentAttribute = .forceRightToLeft
            second_View.semanticContentAttribute = .forceRightToLeft
            third_View.semanticContentAttribute = .forceRightToLeft
            fourth_View.semanticContentAttribute = .forceRightToLeft
            
            
        }
        
                special_ads_cv.dataSource = self
                special_ads_cv.delegate = self
        
                photo_ads_cv.dataSource = self
                photo_ads_cv.delegate = self
        
                video_ads_cv.dataSource = self
                video_ads_cv.delegate = self
        
                text_ads_cv.dataSource = self
                text_ads_cv.delegate = self
        
        firstPV.start()
        firstPV.start(automaticallyShow: true)
        firstPV.setBar(color:UIColor.black, animated:true)
        
        
        secondPV.start()
        secondPV.start(automaticallyShow: true)
        secondPV.setBar(color:UIColor.black, animated:true)
        
        
        thirdPV.start()
        thirdPV.start(automaticallyShow: true)
        thirdPV.setBar(color:UIColor.black, animated:true)
        
        
        fourthPV.start()
        fourthPV.start(automaticallyShow: true)
        fourthPV.setBar(color:UIColor.black, animated:true)
        
        if countData.isEmpty {
            getAdsStatistics()
        }else{
            prepareSideMenu()
        }
        
        getTopDwonAds()
        
        menu_btn.isEnabled = false
        starads_btn.isEnabled = false
        photoads_btn.isEnabled = false
        videoads_btn.isEnabled = false
        textads_btn.isEnabled = false
        self.scrollview.isScrollEnabled = true
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 950)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAds()
        
    }
    
    func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            getAds()
        }
    }
    
    func enterPressed(){
        //do something with typed text if needed
        searchTF.resignFirstResponder()
        getAds()
    }
    
    func changeTap(postion : Int){
        
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "AdsAllVC") as! AllAdsVC
        switch postion {
        case 0:
                navigationController?.popToViewController(self, animated: true)
        
        case 1:
            
            selctedBarIndex = 0
            performSegue(withIdentifier: "AllAdsVC", sender: self)
        case 2:
            selctedBarIndex = 1
            performSegue(withIdentifier: "AllAdsVC", sender: self)
        case 3:
            selctedBarIndex = 2
            performSegue(withIdentifier: "AllAdsVC", sender: self)
        case 4:
            selctedBarIndex = 3
            performSegue(withIdentifier: "AllAdsVC", sender: self)
        default:
            print("LLL")
        }
        if Locale.preferredLanguages[0] != "en" {
            SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)
        }else{
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        }
    }

    
    func navigateToSearchScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "AdsSearchVC") as! AdsSearchVC
        vc.mainVc = self
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func prepareSideMenu(){
        
        menu_btn.isEnabled = true
        // Define the menus
        //let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: ViewController())
        //menuLeftNavigationController.leftSide = true
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! ViewController
        
        menuVC.countData = countData
        menuVC.mainAdsVC = self
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if(collectionView == special_ads_cv){
        return specialAdsList.count > 3 ? 3 : specialAdsList.count
      }
      else if(collectionView == photo_ads_cv){
        return photoAdsList.count > 3 ? 3 : photoAdsList.count
      }
      else if(collectionView == video_ads_cv){
        return videoAdsList.count > 3 ? 3 : videoAdsList.count
      }
      else {
        return textAdsList.count > 3 ? 3 : textAdsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == special_ads_cv){
            let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
            
            cell.config(_Obj: (specialAdsList[indexPath.row]))
            cell.roundedWithBorder(radius: 5)
            if Locale.preferredLanguages[0] == "en"{
                cell.bottom_view.semanticContentAttribute = .forceRightToLeft
            }
            else{
                 cell.bottom_view.semanticContentAttribute = .forceLeftToRight
            }
            
            return cell
        }
        else if(collectionView == photo_ads_cv){
            let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
            
            cell.config(_Obj: (photoAdsList[indexPath.row]))
             cell.roundedWithBorder(radius: 5)
            if Locale.preferredLanguages[0] == "en"{
                cell.bottom_view.semanticContentAttribute = .forceRightToLeft
            }
            else{
                cell.bottom_view.semanticContentAttribute = .forceLeftToRight
            }
            return cell
        }
        else if(collectionView == video_ads_cv){
            let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
            
            cell.config(_Obj: (videoAdsList[indexPath.row]))
             cell.roundedWithBorder(radius: 5)
            if Locale.preferredLanguages[0] == "en"{
                cell.bottom_view.semanticContentAttribute = .forceRightToLeft
            }
            else{
                cell.bottom_view.semanticContentAttribute = .forceLeftToRight
            }
            return cell
        }
        else {
            let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
            
            cell.config(_Obj: (textAdsList[indexPath.row]))
             cell.roundedWithBorder(radius: 5)
            
            if Locale.preferredLanguages[0] == "en"{
                cell.bottom_view.semanticContentAttribute = .forceRightToLeft
            }
            else{
                cell.bottom_view.semanticContentAttribute = .forceLeftToRight
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 127)
    }
    
    func getAds(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Title": searchTF.text ?? "",
            "CategoryId": catId,
            "AdsTo": 0,
            "CityId": cityId,
            "Count": 200,
            "Type": typeId
        ]
        
        print(parameters)
        
        Alamofire.request(ADS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
               // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
               // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                     //   print(json)
                        let adsData = Mapper<AdsData>().map(JSONObject: json)
                        self.specialAdsList = (adsData?.result?.PromotedAds)!
                         self.photoAdsList = (adsData?.result?.ImageAds)!
                         self.videoAdsList = (adsData?.result?.VideoAds)!
                         self.textAdsList = (adsData?.result?.TextAds)!
                        self.special_ads_cv.isHidden = false
                         self.photo_ads_cv.isHidden = false
                         self.video_ads_cv.isHidden = false
                         self.text_ads_cv.isHidden = false
                        self.special_ads_cv.reloadData()
                        self.photo_ads_cv.reloadData()
                        self.video_ads_cv.reloadData()
                        self.text_ads_cv.reloadData()
                        
                        self.firstPV.isHidden = true
                        self.secondPV.isHidden = true
                        
                        self.thirdPV.isHidden = true
                        self.fourthPV.isHidden = true
                        self.adsData = adsData?.result
                        
                        self.starads_btn.isEnabled = true
                        self.photoads_btn.isEnabled = true
                        self.videoads_btn.isEnabled = true
                        self.textads_btn.isEnabled = true
                        

                        
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllAdsVC"{
            let vc = segue.destination as! AllAdsVC
            vc.adsData = self.adsData
            vc.selctedBarIndex = selctedBarIndex
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    func getAdsStatistics(){
        let parameters: Parameters = [
            "AdsTo": 0
        ]
        
        Alamofire.request(ADS_COUNT_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
               // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                     //   print(json)
                        let adsStatData = Mapper<AdsStatData>().map(JSONObject: json)
                        
                        let home = Bundle.main.localizedString(forKey: "home-menu", value: nil, table: "Default")
                        let special = Bundle.main.localizedString(forKey: "special-ads", value: nil, table: "Default")
                        let video = Bundle.main.localizedString(forKey: "video-ads", value: nil, table: "Default")
                        let photo = Bundle.main.localizedString(forKey: "photo-ads", value: nil, table: "Default")
                        let text = Bundle.main.localizedString(forKey: "text-ads", value: nil, table: "Default")
                        //
                        let imagesList = ["Home-Icon.png" , "Special-Ads-Icon.png","pic-ads-Icon.png", "Video-Ads-Icon.png", "Text-Ads-Icon.png"]
                        
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

    
    func getTopDwonAds(){
        let parameters: Parameters = [
            "PlaceId": 4
        ]
        
        Alamofire.request(TOP_DOWN_ADS , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //   print(json)
                        let obj = Mapper<TopDownAdsData>().map(JSONObject: json)
                        
                        self.adImg.kf.setImage(with: URL(string: (obj?.result?.Image)!),
                                        placeholder: nil,
                                        options: [.transition(.fade(1))],
                                        progressBlock: nil,
                                        completionHandler: nil)
                    }
                    
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adsDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        
        if(collectionView == special_ads_cv){
            adsDetailsVC.adObject = specialAdsList[indexPath.row]
        }
        else if(collectionView == photo_ads_cv){
            adsDetailsVC.adObject = photoAdsList[indexPath.row]
        }
        else if(collectionView == video_ads_cv){
            adsDetailsVC.adObject = videoAdsList[indexPath.row]
        }
        else {
            adsDetailsVC.adObject = textAdsList[indexPath.row]
        }

        
        navigationController?.pushViewController(adsDetailsVC, animated: true)
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
    
        navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func starads_clk(_ sender: UIButton) {
        selctedBarIndex = 0
        performSegue(withIdentifier: "AllAdsVC", sender: self)
    }
    
    @IBAction func photoads_clk(_ sender: UIButton) {
        selctedBarIndex = 1
        performSegue(withIdentifier: "AllAdsVC", sender: self)
    }
    
    @IBAction func videoads_clk(_ sender: UIButton) {
        selctedBarIndex = 2
        performSegue(withIdentifier: "AllAdsVC", sender: self)
    }
    
    @IBAction func textads_clk(_ sender: UIButton) {
        selctedBarIndex = 3
        performSegue(withIdentifier: "AllAdsVC", sender: self)
    }
    
}
