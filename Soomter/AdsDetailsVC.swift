//
//  AdsDetailsVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/29/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SideMenu
import JGProgressHUD
import AVFoundation
import AVKit
import MediaPlayer

class AdsDetailsVC: UIViewController ,UITableViewDelegate, UITableViewDataSource
                    ,UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var selected_ads_cv: UICollectionView!
    
    @IBOutlet weak var fav_icon: UIImageView!
    @IBOutlet weak var simi_ads_view: UIView!
    @IBOutlet weak var ads_description: UITextView!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var ads_desc_view: UIView!
    @IBOutlet weak var report_lbl: UILabel!
    @IBOutlet weak var ads_dataTv: UITableView!
    @IBOutlet weak var ads_title: UILabel!
    @IBOutlet weak var top_view: UIView!
    @IBOutlet weak var ads_img: UIImageView!
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var bck_btn: UIButton!
    
    var similarAds : [AdDetailsData.Result.SimilarAds] = []
    var adsInformList : [String] = []
    
    @IBOutlet weak var play_icon: UIImageView!
    
     var adObject : AdsData.AdsClass!
    var hud : JGProgressHUD!
    var videUrl = ""
    
    @IBOutlet weak var settings_img: UIImageView!
    //@IBOutlet weak var prentview_height: NSLayoutConstraint!
    
    func navigateToSettingsScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        settings_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher = UITapGestureRecognizer(
            
            target: self, action:  #selector (self.navigateToSettingsScreen(_:)))
        
        settings_img.addGestureRecognizer(gestureSwift2AndHigher)

        menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] == "en"{
           // bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            menu_view.semanticContentAttribute = .forceRightToLeft
            simi_ads_view.semanticContentAttribute = .forceRightToLeft
        }
        else{
            menu_view.semanticContentAttribute = .forceLeftToRight
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            simi_ads_view.semanticContentAttribute = .forceLeftToRight
            top_view.semanticContentAttribute = .forceLeftToRight
        }
        
        top_view.roundedWithBorder(radius: 5)
        
        ads_img.roundCorners(_: [.topLeft, .topRight], radius: 5)
        
        report_lbl.roundedWithBorder(radius: 13)
        
        ads_desc_view.roundedWithBorder(radius: 5)
                
        if adObject.type == 3 {
            play_icon.isHidden = false
        }
        
        ads_dataTv.delegate = self
        ads_dataTv.dataSource = self
        
        selected_ads_cv.dataSource = self
        selected_ads_cv.delegate = self
        
        getAdDetails()
        prepareSideMenu()
        
        ads_description.sizeThatFits(CGSize(width: ads_description.frame.size.width, height: ads_description.frame.size.height))

        //prentview_height.constant = 1100
        //self.view.layoutIfNeeded()
        self.scrollview.isScrollEnabled = true
        
        play_icon.isUserInteractionEnabled = true
        ads_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher2 = UITapGestureRecognizer( target: self, action:  #selector (self.playVideo(_:)))
        
        play_icon.addGestureRecognizer(gestureSwift2AndHigher2)
        ads_img.addGestureRecognizer(gestureSwift2AndHigher2)
        
    }
    
    var avPlayer : AVPlayer! = AVPlayer()
    
    func playVideo(_ sender:UITapGestureRecognizer)  {
        if let url = URL(string: videUrl){
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
//            let player = AVPlayer(url: url)
//
//            let avPlayerController = AVPlayerViewController()
//
//            avPlayerController.player = player;
//            var frame = CGRect(x: self.view.bounds.midX / 2, y: self.view.bounds.midY / 2, width: self.view.frame.width / 2, height: self.view.frame.height / 2)
//            avPlayerController.view.frame = frame ;
//            avPlayerController.player?.play()
//            self.addChildViewController(avPlayerController)
//            self.view.addSubview(avPlayerController.view);
        }
        else{
            displayToastMessage("Not supported")
        }
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 1100)
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
    
    
    func getAdDetails(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Id": adObject.id,
            "CurrentUserId": "",
            "Type": adObject.type
        ]
        
        Alamofire.request(AD_DETAILS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                self.hud.dismiss()
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let adsData = Mapper<AdDetailsData>().map(JSONObject: json)
                        
                        self.ads_description.text = adsData?.result?.Details
                        
                        var frame = self.ads_description.frame
                        frame.size.height = self.ads_description.contentSize.height
                        self.ads_description.frame = frame

                        
                        self.ads_desc_view.frame.size = CGSize(width: self.ads_desc_view.frame.width, height: self.ads_description.frame.height + 25)
                        
                        self.ads_title.text = adsData?.result?.CompanyName
                        
                        self.similarAds = (adsData?.result?.ListSemilarAds)!
                        
                        if self.similarAds.count > 0 {
                            self.simi_ads_view.isHidden = false
                            self.selected_ads_cv.reloadData()
                        }
                        
                        self.videUrl = adsData?.result?.VedioUrl ?? ""
                        
                        if let company = adsData?.result?.CompanyName{
                            self.adsInformList.append(company)
                        }
                        if let city = adsData?.result?.CityName{
                            self.adsInformList.append(city)
                        }
                        if let category = adsData?.result?.CategoryName{
                            self.adsInformList.append(category)
                        }
                        if let subCategory = adsData?.result?.SubCategoryName{
                            self.adsInformList.append(subCategory)
                        }
                        if let phone = adsData?.result?.Phone{
                            self.adsInformList.append(phone)
                        }
                        if let mobile = adsData?.result?.Mobile{
                            self.adsInformList.append(mobile)
                        }
                        if let url = adsData?.result?.Url{
                            self.adsInformList.append(url)
                        }
                        self.ads_dataTv.reloadData()
                        
                        if((adsData?.result?.IsFavorite) != nil){
                            self.fav_icon.isHidden = false
                        }
                        
                        if self.adObject.type == 3 {
                            if let url = URL(string: getRightUrl(inputID:
                                (adsData?.result?.VedioUrl)!)){
                                self.ads_img.kf.setImage(with: url,
                                                         placeholder: nil,
                                                         options: [.transition(.fade(1))],
                                                         progressBlock: nil,
                                                         completionHandler: nil)
                            }
                        
                        }
                        else {
                            if let url = URL(string: (adsData?.result?.Image)!){
                                self.ads_img.kf.setImage(with: url,
                                                 placeholder: nil,
                                                 options: [.transition(.fade(1))],
                                                 progressBlock: nil,
                                               completionHandler: nil)
                                }
                            }
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    
    @IBAction func menubtn_clk(_ sender: UIButton) {if Locale.preferredLanguages[0] == "en" {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }else{
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func show_all_clk(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adsInformList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsInformCell", for: indexPath) as! AdsInformsCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_name: self.adsInformList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return similarAds.count > 3 ? 3 : similarAds.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
            
            cell.config2(_Obj: (similarAds[indexPath.row]))
            cell.roundedWithBorder(radius: 5)
            
            return cell
        }

}
