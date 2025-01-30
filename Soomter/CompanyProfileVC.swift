//
//  CompanyProfileVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/11/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Cosmos
import JGProgressHUD


class CompanyProfileVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource
                        ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!

    @IBOutlet weak var acknowldge_lbl: UILabel!
    var mostWatchedObj : MostWatchedComps.Result!
    var companyObj : CompaniesData.Items!
    
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var company_name: UILabel!
    @IBOutlet weak var company_img: UIImageView!
    
    @IBOutlet weak var ratingbar: CosmosView!
    @IBOutlet weak var gplust_btn: UIButton!
    @IBOutlet weak var fb_btn: UIButton!
    @IBOutlet weak var twitter_btn: UIButton!
    @IBOutlet weak var instg_btn: UIButton!
    @IBOutlet weak var youtube_btn: UIButton!
   
    
    @IBOutlet weak var follow_comp_btn: UIButton!
    @IBOutlet weak var comp_wn_btn: UIButton!
    
    @IBOutlet weak var details_container: UIView!
    @IBOutlet weak var details_icon: UIImageView!
    @IBOutlet weak var views_count_lbl: UILabel!
    @IBOutlet weak var views_title_lbl: UILabel!
    
    @IBOutlet weak var branches_container: UIView!
    @IBOutlet weak var branches_icon: UIImageView!
    @IBOutlet weak var branches_count_lbl: UILabel!
    @IBOutlet weak var branches_title_lbl: UILabel!
    
    @IBOutlet weak var prods_container: UIView!
    @IBOutlet weak var prods_icon: UIImageView!
    @IBOutlet weak var prods_count_lbl: UILabel!
    @IBOutlet weak var prods_title_lbl: UILabel!
    
    @IBOutlet weak var ads_container: UIView!
    @IBOutlet weak var ads_icon: UIImageView!
    @IBOutlet weak var ads_count_lbl: UILabel!
    @IBOutlet weak var ads_title_lbl: UILabel!
    
    @IBOutlet weak var evs_container: UIView!
    @IBOutlet weak var evs_icon: UIImageView!
    @IBOutlet weak var evs_count_lbl: UILabel!
    @IBOutlet weak var evs_title_lbl: UILabel!
    
    @IBOutlet weak var joints_container: UIView!
     @IBOutlet weak var joints_firstview: UIView!
     @IBOutlet weak var joints_secondview: UIView!
    @IBOutlet weak var joints_icon: UIImageView!
    @IBOutlet weak var joints_title_lbl: UILabel!
    
    @IBOutlet weak var details_view: UIView!
    @IBOutlet weak var informs_tv: UITableView!
    @IBOutlet weak var acknwoledge_tv: UITableView!
    @IBOutlet weak var selected_inis_view: UIView!
    @IBOutlet weak var selected_ins_cv: UICollectionView!
    @IBOutlet weak var inner_detailsview: UIView!
    @IBOutlet weak var test_cons: NSLayoutConstraint!
    @IBOutlet weak var top_cons: NSLayoutConstraint!
    @IBOutlet weak var ackngtv_height: NSLayoutConstraint!
    @IBOutlet weak var informstv_height: NSLayoutConstraint!
    @IBOutlet weak var branchstv_height: NSLayoutConstraint!
    
    @IBOutlet weak var branches_view: UIView!
    @IBOutlet weak var branches_tv: UITableView!
    
    @IBOutlet weak var ads_view: UIView!
    @IBOutlet weak var ads_cv: UICollectionView!
    
    @IBOutlet weak var evs_view: UIView!
    @IBOutlet weak var events_tv: UITableView!
    
    @IBOutlet weak var prods_view: UIView!
    @IBOutlet weak var products_cv: UICollectionView!
    
    @IBOutlet weak var joins_view: UIView!
    @IBOutlet weak var mobilenum_textfield: UITextField!
    @IBOutlet weak var mail_textfield: UITextField!
    @IBOutlet weak var reg_btn: UIButton!
    
    @IBOutlet weak var noProdsDataView: UIView!
    @IBOutlet weak var noEventsDataView: UIView!
    @IBOutlet weak var noAdsDataView: UIView!
    @IBOutlet weak var noBranchsDataView: UIView!
    
    @IBOutlet weak var ad_lbl: UILabel!
    
    @IBOutlet weak var ad_text_lbl: UILabel!
    var user: User?
    var googleLink : String = ""
    var fbLink : String = ""
    var twitterLink : String = ""
    var youtubeLink : String = ""
    var instgLink : String = ""
    var noLinkText : String!
    
    var informsList : [Informations] = []
    var ackngsList : [Informations] = []
    var similarComps : [CompanyProfileData.SimilarCompanies] = []
    var branchesList : [CompanyProfileData.BranchsCompany] = []
    var prodsList : [CompanyProfileData.ListProducts] = []
    var adsList : [CompanyProfileData.ListAds] = []
    var eventsList : [CompanyProfileData.ListEvents] = []
    var hud  : JGProgressHUD!
    
    var userID = ""
    var isFolow = 0
    
    @IBOutlet weak var ad_view: UIView!
    @IBOutlet weak var settings_img: UIImageView!
    
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
        
        noLinkText = Bundle.main.localizedString(forKey: "no_link", value: nil, table: "Default")
        
        reg_btn.roundedWithBorder(radius: 10)
        joints_firstview.roundedWithBorder(radius: 8)
        joints_secondview.roundedWithBorder(radius: 8)
        
        ad_lbl.roundedWithBorder(radius: 8)
        
        comp_wn_btn.roundedWithBorder(radius: 5)
        comp_wn_btn.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if !(companyObj == nil && mostWatchedObj == nil){
            title_lbl.text = mostWatchedObj != nil ? mostWatchedObj.CompanyName : companyObj.CompanyName
            company_name.text = mostWatchedObj != nil ? mostWatchedObj.CompanyName : companyObj.CompanyName
        }
        
        details_container.roundedWithBorder(radius: 5)
        prods_container.roundedWithBorder(radius: 5)
        ads_container.roundedWithBorder(radius: 5)
        evs_container.roundedWithBorder(radius: 5)
        branches_container.roundedWithBorder(radius: 5)
        joints_container.roundedWithBorder(radius: 5)
        
        details_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        details_icon.image = UIImage(named : "Comp-Profie-Views-Icon.png")
        views_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        views_title_lbl.textColor = hexStringToUIColor(hex: "#212121")

        if mostWatchedObj != nil {
            if let url = mostWatchedObj.Logo{
            self.company_img.kf.setImage(with: URL(string: url),
                                 placeholder: nil,
                                 options: [.transition(.fade(1))],
                                 progressBlock: nil,
                                 completionHandler: nil)
            }
            self.isFolow = mostWatchedObj.IsFlowed ?? 0
            self.ratingbar.rating = mostWatchedObj.AverageRating!
            
        }else if companyObj != nil{
            if let url = companyObj.Logo{
                self.company_img.kf.setImage(with: URL(string: url),
                                             placeholder: nil,
                                             options: [.transition(.fade(1))],
                                             progressBlock: nil,
                                             completionHandler: nil)
            }
            self.isFolow = companyObj.IsFlowed ?? 0
            self.ratingbar.rating = companyObj.AverageRating!
        }

        
        details_view.isHidden = false
        //self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1100)
        
        getCompanyProfile()
        
        if let customView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as? NoDataView {
            //customView.title_lbl.text = "sdfsF"
            
        }
        
        let detailsVoewGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setDetailsView(_:)))
        details_container.addGestureRecognizer(detailsVoewGest)
        let branchsesViewGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setBrancsView(_:)))
        branches_container.addGestureRecognizer(branchsesViewGest)
        let prodsViewGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setProdsView(_:)))
        prods_container.addGestureRecognizer(prodsViewGest)
        let asdGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setAdsView(_:)))
        ads_container.addGestureRecognizer(asdGest)
        let evsGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setEvsView(_:)))
        evs_container.addGestureRecognizer(evsGest)
        let joinsGest = UITapGestureRecognizer(
            target: self, action:  #selector (self.setJoinsView(_:)))
        joints_container.addGestureRecognizer(joinsGest)

        informs_tv.delegate = self
        informs_tv.dataSource = self
        acknwoledge_tv.dataSource = self
        acknwoledge_tv.delegate = self
        selected_ins_cv.delegate = self
        selected_ins_cv.dataSource = self
        branches_tv.delegate = self
        branches_tv.dataSource = self
        products_cv.delegate = self
        products_cv.dataSource = self
        ads_cv.delegate = self
        ads_cv.dataSource = self
        events_tv.delegate = self
        events_tv.dataSource = self
        
        follow_comp_btn.isUserInteractionEnabled = true
        
        follow_comp_btn.addTarget(self, action: #selector(followCompany), for: .touchUpInside)

        informs_tv.roundedWithBorder(radius: 8)
        acknwoledge_tv.roundedWithBorder(radius: 8)
        self.scrollview.isScrollEnabled = true

        if Locale.preferredLanguages[0] == "en"{
            ad_view.semanticContentAttribute = .forceRightToLeft
            details_view.semanticContentAttribute = .forceRightToLeft
            inner_detailsview.semanticContentAttribute = .forceRightToLeft
            details_container.semanticContentAttribute = .forceRightToLeft
            
            branches_container.semanticContentAttribute = .forceRightToLeft
            prods_container.semanticContentAttribute = .forceRightToLeft
            evs_container.semanticContentAttribute = .forceRightToLeft
            ads_container.semanticContentAttribute = .forceRightToLeft
            joints_container.semanticContentAttribute = .forceRightToLeft
            prods_view.semanticContentAttribute = .forceRightToLeft
            evs_view.semanticContentAttribute = .forceRightToLeft
            ad_view.semanticContentAttribute = .forceRightToLeft
            joins_view.semanticContentAttribute = .forceRightToLeft
            branches_view.semanticContentAttribute = .forceRightToLeft
            selected_inis_view.semanticContentAttribute = .forceRightToLeft
            informs_tv.semanticContentAttribute = .forceRightToLeft
            acknwoledge_tv.semanticContentAttribute = .forceRightToLeft
            selected_ins_cv.semanticContentAttribute = .forceLeftToRight
    
            
            ads_cv.semanticContentAttribute = .forceRightToLeft
        }
        else{
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            ad_view.semanticContentAttribute = .forceLeftToRight
            details_view.semanticContentAttribute = .forceLeftToRight
            inner_detailsview.semanticContentAttribute = .forceLeftToRight
            details_container.semanticContentAttribute = .forceLeftToRight
            
            branches_container.semanticContentAttribute = .forceLeftToRight
            prods_container.semanticContentAttribute = .forceLeftToRight
            evs_container.semanticContentAttribute = .forceLeftToRight
            ads_container.semanticContentAttribute = .forceLeftToRight
            joints_container.semanticContentAttribute = .forceLeftToRight
            prods_view.semanticContentAttribute = .forceLeftToRight
            evs_view.semanticContentAttribute = .forceLeftToRight
            ad_view.semanticContentAttribute = .forceLeftToRight
            joins_view.semanticContentAttribute = .forceLeftToRight
            branches_view.semanticContentAttribute = .forceLeftToRight
            selected_inis_view.semanticContentAttribute = .forceLeftToRight
            informs_tv.semanticContentAttribute = .forceLeftToRight
            acknwoledge_tv.semanticContentAttribute = .forceLeftToRight
            selected_ins_cv.semanticContentAttribute = .forceRightToLeft
            ads_cv.semanticContentAttribute = .forceLeftToRight
        }
        
        prentview_height.constant = 1200
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 1300)
        
        scrollview.isUserInteractionEnabled = true;
        scrollview.isExclusiveTouch = true;
        
        scrollview.canCancelContentTouches = true;
        scrollview.delaysContentTouches = true;
    }
    
    func followCompany(){
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)

        let parameters: Parameters = [
            "CompanyId": mostWatchedObj.id != 0 ? mostWatchedObj.id! : companyObj.id,
            "UserId": user?.result?.id
        ]
        
            Alamofire.request(isFolow == 0 ? FOLLOW_COMPANY_URL : UNFOLLOW_COMPANY_URL, method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //      print("JSON: \(json)") // serialized json response
                        //self.follow_comp_btn.isHidden = true
                        self.isFolow = self.isFolow == 0 ? 5 : 0
                        
                        displayToastMessage(self.isFolow == 5 ? Bundle.main.localizedString(forKey: "folow-sucess", value: nil, table: "Default")
                            : Bundle.main.localizedString(forKey: "unfolow-sucess", value: nil, table: "Default"))
                    }
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
            }
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
   //    self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1100)
    }
    
   
    @IBAction func regbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            user = Mapper<User>().map(JSONObject: recovedUserJson)
            //reg_btn.isUserInteractionEnabled = true
        }
        else{
            
            displayToastMessage(Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default"))
        }
        
     //   displayToastMessage("FDDGDFGD")
    }
    @IBAction func leftclk_btn(_ sender: UIButton) {
    }
    @IBAction func rightclk_btn(_ sender: UIButton) {
    }
    @IBAction func gplusbtn_clk(_ sender: UIButton) {
        guard let url = URL(string: googleLink) else {
            displayToastMessage(noLinkText)
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func fbbtn_clk(_ sender: UIButton) {
        guard let url = URL(string: fbLink) else {
            displayToastMessage(noLinkText)
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func twitterbtn_clk(_ sender: UIButton){
        guard let url = URL(string: twitterLink) else {
            displayToastMessage(noLinkText)
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func instgbtn_clk(_ sender: UIButton) {
        guard let url = URL(string: instgLink) else {
            displayToastMessage(noLinkText)
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func youttubebtn_clk(_ sender: UIButton){
        guard let url = URL(string: youtubeLink) else {
            displayToastMessage(noLinkText)
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func setDetailsView(_ sender:UITapGestureRecognizer)  {
       clearSelection()
        details_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        details_icon.image = UIImage(named : "Comp-Profie-Views-Icon.png")
        views_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        views_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
        details_view.isHidden = false
    }
    func setProdsView(_ sender:UITapGestureRecognizer)  {
        clearSelection()
        prods_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        prods_icon.image = UIImage(named : "Comp-Profile-Prods-Icon.png")
        prods_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        prods_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
        prods_view.isHidden = false
    }
    func setBrancsView(_ sender:UITapGestureRecognizer)  {
        clearSelection()
        branches_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        branches_icon.image = UIImage(named : "Comp-Profie-Brancehs-Icon.png")
        branches_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        branches_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
           branches_view.isHidden = false
    }
    func setAdsView(_ sender:UITapGestureRecognizer)  {
        clearSelection()
        ads_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ads_icon.image = UIImage(named : "Comp-Profie-Ads-Icon.png")
        ads_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        ads_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
           ads_view.isHidden = false
    }
    func setEvsView(_ sender:UITapGestureRecognizer)  {
        clearSelection()
        evs_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        evs_icon.image = UIImage(named : "Comp-Profile-Evs-Icon.png")
        evs_count_lbl.textColor = hexStringToUIColor(hex: "#D9B878")
        evs_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
           evs_view.isHidden = false
    }
    func setJoinsView(_ sender:UITapGestureRecognizer)  {
        clearSelection()
        joints_container.dropShadow(color: hexStringToUIColor(hex: "#A0A0A0"), opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        joints_icon.image = UIImage(named : "Comp-Profie-Joinus-Icon.png")
        joints_title_lbl.textColor = hexStringToUIColor(hex: "#212121")
        joins_view.isHidden = false
    }
    
    func clearSelection(){
        details_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        details_icon.image = UIImage(named : "Comp-Profie-UnactiveViews-Icon.png")
        views_count_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        views_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
        branches_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
         branches_icon.image = UIImage(named : "Comp-Profie-UnactiveBrancehs-Icon.png")
         branches_count_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        branches_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
        prods_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        prods_icon.image = UIImage(named : "Comp-Profile-UnactiveProds-Icon.png")
        prods_count_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        prods_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
        ads_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ads_icon.image = UIImage(named : "Comp-Profie-UnactiveAds-Icon.png")
        ads_count_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        ads_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
        evs_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        evs_icon.image = UIImage(named : "Comp-Profile-UnactiveEvs-Icon.png")
        evs_count_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        evs_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
        joints_container.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        joints_icon.image = UIImage(named : "Comp-Profie-UnactiveJoinus-Icon.png")
        joints_title_lbl.textColor = hexStringToUIColor(hex: "#CBCCCE")
        
           details_view.isHidden = true
           branches_view.isHidden = true
           prods_view.isHidden = true
           ads_view.isHidden = true
           evs_view.isHidden = true
           joins_view.isHidden = true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == informs_tv{
            let cell: InformsCell = tableView.dequeueReusableCell(withIdentifier: "InformsCell") as! InformsCell
            cell.config(obje: informsList[indexPath.row])
            if Locale.preferredLanguages[0] == "en"{
                cell.semanticContentAttribute = .forceRightToLeft
                cell.semanticContentAttribute = .forceRightToLeft
            }
            else{
                cell.semanticContentAttribute = .forceLeftToRight
                cell.semanticContentAttribute = .forceLeftToRight
            }
            return cell
        }
        else if tableView == acknwoledge_tv{
            let cell: InformsCell = tableView.dequeueReusableCell(withIdentifier: "InformsCell") as! InformsCell
            if Locale.preferredLanguages[0] == "en"{
                cell.semanticContentAttribute = .forceRightToLeft
                cell.semanticContentAttribute = .forceRightToLeft
            }else{
                
                cell.semanticContentAttribute = .forceLeftToRight
                cell.semanticContentAttribute = .forceLeftToRight
            }
            cell.config(obje: ackngsList[indexPath.row])
            return cell
        }
        else if tableView == branches_tv{
            let cell: BranchesCell = tableView.dequeueReusableCell(withIdentifier: "BranchesCell") as! BranchesCell
            cell.config(_obj: branchesList[indexPath.row])

            return cell
        }
        else if tableView == events_tv{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
            //cell.albl?.text = self.animals[indexPath.row]
            cell.config2(_obj: self.eventsList[indexPath.row])
            
            var frame = tableView.frame
            frame.size.height = tableView.contentSize.height
            tableView.frame = frame
            
            return cell

        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == informs_tv{
//            var frame = tableView.frame
//            frame.size.height = tableView.contentSize.height
//            tableView.frame = frame
            informstv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()

            acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            test_cons.constant = 20
            acknowldge_lbl.layoutIfNeeded()
            //acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
//            inner_detailsview.addConstraint(NSLayoutConstraint(item: acknowldge_lbl, attribute: .top,
//                                                               relatedBy: .equal, toItem: tableView,
//                                                               attribute: .bottom, multiplier: 0, constant: -20))

        }
        else if tableView == branches_tv{
            informstv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()

        }
        else if tableView == acknwoledge_tv{
            //            var frame = tableView.frame
            //            frame.size.height = tableView.contentSize.height
            //            tableView.frame = frame
            ackngtv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
            top_cons.constant = 60
            //top_cons_id
            let filteredConstraints = selected_inis_view.constraints.filter { $0.identifier == "top_cons_id" }
            if let yourConstraint = filteredConstraints.first {
                // DO YOUR LOGIC HERE
                yourConstraint.constant = 60
            }
            selected_inis_view.layoutIfNeeded()
//            acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
//            test_cons.constant = 20
//            acknowldge_lbl.layoutIfNeeded()
            //acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            //            inner_detailsview.addConstraint(NSLayoutConstraint(item: acknowldge_lbl, attribute: .top,
            //                                                               relatedBy: .equal, toItem: tableView,
            //                                                               attribute: .bottom, multiplier: 0, constant: -20))
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == informs_tv{
            return informsList.count
        }
        else if tableView == acknwoledge_tv{
            return ackngsList.count
        }
        else if tableView == branches_tv{
            return branchesList.count
        }
        else if tableView == events_tv{
            return eventsList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == selected_ins_cv {
            return similarComps.count
        }
        else  if collectionView == products_cv {
            return prodsList.count
        }
        else  if collectionView == ads_cv {
            return adsList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selected_ins_cv {
            let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
        
            cell.config3(_Obj: (similarComps[indexPath.row]))
            cell.roundedWithBorder(radius: 5)
            if Locale.preferredLanguages[0] == "en"{
                cell.contentView.semanticContentAttribute = .forceRightToLeft
                cell.bottom_view.semanticContentAttribute = .forceRightToLeft
            }
            else{
                cell.contentView.semanticContentAttribute = .forceLeftToRight
                cell.bottom_view.semanticContentAttribute = .forceLeftToRight
            }
            return cell

        }
        else if collectionView == products_cv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellProdsCell", for: indexPath) as! BestSellProdsCell
            //cell.albl?.text = self.animals[indexPath.row]
            cell.config3(_obj: self.prodsList[indexPath.row])
            
            return cell
        }
        else if collectionView == ads_cv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadBadBoys", for: indexPath) as! AdsCell
            //print(adsData?.PromotedAds?[indexPath.row].Title)
            cell.config4(_Obj: (adsList[indexPath.row]))
            cell.roundedWithBorder(radius: 5)
            
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
//                let cellWidth = (view.frame.width - max(0, 3 - 1)*horizontalSpacing)/3
//                flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
//                
                if adsList.count > 3 {
                                    let padding: CGFloat =  25
                                    let collectionViewSize = collectionView.frame.size.width - padding
                                    flowLayout.itemSize = CGSize(width: collectionViewSize/3, height: collectionViewSize/2.2)
                                }
                                flowLayout.itemSize =  CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
          }
            
            return cell
        }

        return UICollectionViewCell()
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == ads_cv {
//            if adsList.count > 3 {
//                let padding: CGFloat =  25
//                let collectionViewSize = collectionView.frame.size.width - padding
//                return CGSize(width: collectionViewSize/3, height: collectionViewSize/2.2)
//            }
//            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
//        }
//        else if collectionView == selected_ins_cv {
//            return (collectionView.cellForItem(at: indexPath)?.frame.size)!
//        }
//        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
//    }
    
    
    func getCompanyProfile(){
        //mostWatchedObj.id != 0 ? mostWatchedObj.id! : companyObj.id!
       let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Id": userID != "" ? userID : (mostWatchedObj != nil ? mostWatchedObj.id! : companyObj.id!),//600408 //599576
            "UserId": userID,
        ]
        
        Alamofire.request(COMPANIES_PROFILE_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                self.hud.dismiss()
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let data = Mapper<CompanyProfileData>().map(JSONObject: json)
                        if data == nil{
                            return
                        }
                        
                        
                        if let link = data?.result?.GooglePlus{
                            self.googleLink = link
                        }
                        else{
                         //   self.gplust_btn.tintColor = hexStringToUIColor(hex: "#696969")
                            //Fb-Icon
                            let origImage = UIImage(named: "Googleplus-Icon")
                            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                            self.gplust_btn.setImage(tintedImage, for: .normal)
                            self.gplust_btn.tintColor = hexStringToUIColor(hex: "#696969")

                            
                        }
                        if let link = data?.result?.Facebook{
                            self.fbLink = link
                        }else{
                            let origImage = UIImage(named: "Fb-Icon")
                            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                            self.fb_btn.setImage(tintedImage, for: .normal)
                            self.fb_btn.tintColor = hexStringToUIColor(hex: "#696969")

                        }
                        if let link = data?.result?.Twitter{
                            self.twitterLink = link
                        }
                        else{
                            
                            let origImage = UIImage(named: "Twitter-Icon")
                            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                            self.twitter_btn.setImage(tintedImage, for: .normal)
                            self.twitter_btn.tintColor = hexStringToUIColor(hex: "#696969")

                        }
                        if let link = data?.result?.Instagram{
                            self.instgLink = link
                        }
                        else{
                            let origImage = UIImage(named: "Instgram-Icon")
                            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                            self.instg_btn.setImage(tintedImage, for: .normal)
                            self.instg_btn.tintColor = hexStringToUIColor(hex: "#696969")

                        }
                        if let link = data?.result?.YouTube{
                            self.youtubeLink = link
                        }
                        else{
                            let origImage = UIImage(named: "Youtube-Icon")
                            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                            self.youtube_btn.setImage(tintedImage, for: .normal)
                            self.youtube_btn.tintColor = hexStringToUIColor(hex: "#696969")
                        }
                        if let count = data?.result?.CompanyViewsCount{
                            self.views_count_lbl.text = String(describing: count)
                        }
                        if let count = data?.result?.CompanyBanchesCount{
                            self.branches_count_lbl.text = String(describing: count)
                        }
                        if let count = data?.result?.CompanyProductsCount{
                            self.prods_count_lbl.text = String(describing: count)
                        }
                        if let count = data?.result?.CompanyAdsCount{
                            self.ads_count_lbl.text = String(describing: count)
                        }
                        if let count = data?.result?.CompanyEventsCount{
                            self.evs_count_lbl.text = String(describing: count)
                        }
                        if let unifiedNum = data?.result?.UnifiedNumber {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "unified-num", value: nil, table: "Default"), value: unifiedNum)
                            self.informsList.append(obje)
                        }
                        if let mob = data?.result?.Mobile {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "mob", value: nil, table: "Default"), value: mob)
                            self.informsList.append(obje)
                            
                        }
                        if let phone = data?.result?.Phone {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "phone", value: nil, table: "Default"), value: phone)
                            self.informsList.append(obje)
                        }
                        if let fax = data?.result?.Fax {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "fax", value: nil, table: "Default"), value: fax)
                            self.informsList.append(obje)
                        }
                        if let mailbox = data?.result?.MailBox {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "mailbox", value: nil, table: "Default"), value: "\(mailbox)")
                            self.informsList.append(obje)
                        }
                        if let site = data?.result?.Website {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "website", value: nil, table: "Default"), value: site)
                            self.informsList.append(obje)
                        }
                        if let email = data?.result?.AdsEmail {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "fax", value: nil, table: "Default"), value: email)
                            self.informsList.append(obje)
                        }
                        if let email = data?.result?.AdsEmail {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "fax", value: nil, table: "Default"), value: email)
                            self.informsList.append(obje)
                        }
                        if let log = data?.result?.CommercialRegistrationNo {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "log", value: nil, table: "Default"), value: log)
                            self.ackngsList.append(obje)
                        }
                        if let catg = data?.result?.CatgoryName {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "ins_catg", value: nil, table: "Default"), value: catg)
                            self.ackngsList.append(obje)
                        }
                        if let field = data?.result?.FieldName {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "ins_activity", value: nil, table: "Default"), value: field)
                            self.ackngsList.append(obje)
                        }
                        if let address = data?.result?.Address {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "main_branch", value: nil, table: "Default"), value: address)
                            self.ackngsList.append(obje)
                        }
                        if let count = data?.result?.CompanyBanchesCount {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "branches_num", value: nil, table: "Default"), value: "\(count)")
                            self.ackngsList.append(obje)
                        }
                        if let worktime = data?.result?.Sunday_Thursday {
                            let obje = Informations(title: Bundle.main.localizedString(forKey: "worktime", value: nil, table: "Default"), value: worktime)
                            self.ackngsList.append(obje)
                        }
                        if data?.result?.TextAdRequests != nil {
                            self.ad_text_lbl.text = data?.result?.TextAdRequests?.count == 0 ? "" : data?.result?.TextAdRequests?[0].TitleKey ?? ""
                        }
                        self.similarComps = (data?.result?.SimilarCompanies) ?? []
                        self.branchesList = (data?.result?.BranchsCompany) ?? []
                        self.prodsList = (data?.result?.ListProducts) ?? []
                        self.adsList = (data?.result?.ListAds) ?? []
                        self.eventsList = (data?.result?.ListEvents) ?? []
                        self.selected_ins_cv.reloadData()
                        self.acknwoledge_tv.reloadData()
                        self.informs_tv.reloadData()
                        self.branches_tv.reloadData()
                        self.products_cv.reloadData()
                        self.ads_cv.reloadData()
                        self.events_tv.reloadData()
                        
                        if self.prodsList.count == 0{
                            self.noProdsDataView.isHidden = false
                        }
                        if self.adsList.count == 0{
                            self.noAdsDataView.isHidden = false
                        }
                        if self.branchesList.count == 0{
                            self.noBranchsDataView.isHidden = false
                        }
                        if self.eventsList.count == 0{
                            self.noEventsDataView.isHidden = false
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
    
    func followComp(){
        let parameters: Parameters = [
            "CompanyId": Locale.preferredLanguages[0],
            "UserId": user!.result?.id ?? 0
         ]
        
        Alamofire.request(FOLLOW_COMP_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                       
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
struct Informations {
    let title: String
    let value: String
}
