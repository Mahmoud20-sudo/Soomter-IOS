//
//  EventsVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SideMenu
import PagingTableView

class EventsVC: UIViewController, PagingTableViewDelegate, UITableViewDataSource , UITableViewDelegate{

     @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: MSProgressView!
    @IBOutlet weak var events_ptv: PagingTableView!
    @IBOutlet weak var search_container: UIView!
    @IBOutlet weak var serch_img: UIImageView!
    @IBOutlet weak var options_img: UIImageView!
    
    @IBOutlet weak var adImg: UIImageView!
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var fav_lbl: UILabel!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    @IBOutlet weak var menu_btn: UIButton!
    
    var eventsList : [EventsData.Items] = []
    var eventTypeId = 0
    
    @IBOutlet weak var menu_view: UIView!
    
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
        
        
        menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] != "en"{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        menu_btn.isEnabled = false
        
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
            //         bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            events_ptv.semanticContentAttribute = .forceLeftToRight
            menu_view.semanticContentAttribute = .forceLeftToRight
        }
        else{
            menu_view.semanticContentAttribute = .forceRightToLeft
            //bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            events_ptv.semanticContentAttribute = .forceRightToLeft

        }

        events_ptv.dataSource = self
        events_ptv.pagingDelegate = self
        events_ptv.delegate = self
        
        progressView.isHidden = true
        
        
        fav_btn.isUserInteractionEnabled = true
        fav_lbl.isUserInteractionEnabled = true
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToFavScreen(_:)))
        fav_lbl.addGestureRecognizer(gestureSwift2AndHigher2)
        
        
        getEventsStatistics()
        getTopDwonAds()
        self.scrollView.isScrollEnabled = true
        
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width , height: 900)
    }
    
    func navigateToSearchScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "EventsSearchVC") as! EventsSearchVC
        vc.mainVc = self
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func getTopDwonAds(){
        let parameters: Parameters = [
            "PlaceId": 2
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

    
    func changeTypeEvent(eventTypeId : Int){
        self.eventTypeId = eventTypeId
        self.eventsList = []
        loadData(at: 0) { contents in
            self.eventsList = contents
            self.events_ptv.reloadData()
        }
        if Locale.preferredLanguages[0] != "en" {
            SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)
        }else{
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func favbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User"){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "EventsFavVC") as! EventsFavVC
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
        }
    }
    
    func navigateToFavScreen(_ sender:UITapGestureRecognizer)  {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User"){
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
            "EventsFavVC") as! EventsFavVC
            navigationController?.pushViewController(vc,
                                                 animated: true)
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
        }
    }
    
    func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.endEditing(true)
            progressView.isHidden = false
            self.eventsList = []
            loadData(at: 0) { contents in
                self.progressView.isHidden = true
                self.eventsList = contents
                self.events_ptv.reloadData()
            }
        }
    }
    
    func enterPressed(){
        //do something with typed text if needed
        progressView.isHidden = false
        searchTF.resignFirstResponder()
        self.eventsList = []
        reloadData()
    }

    func reloadData(){
        loadData(at: 0) { contents in
            self.progressView.isHidden = true
            self.eventsList = contents
            if self.eventsList.isEmpty{
                let msg = Bundle.main.localizedString(forKey: "no_result", value: nil, table: "Default")
                displayToastMessage(msg)
            }
            
            self.events_ptv.isLoading = false
            self.events_ptv.reloadData()
        }
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

    let numberOfItemsPerPage = 10
    var catId = 0
    var cityId = 0
    var fromDate = ""
    var toDate = ""

    func loadData(at page: Int, onComplete: @escaping ([EventsData.Items]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let firstIndex = page * self.numberOfItemsPerPage
            guard firstIndex < self.eventsList.count else {
                let parameters: Parameters = [
                    "Lang": Locale.preferredLanguages[0],
                    "FromDate": self.fromDate,
                    "ToDate": self.toDate,
                    "CategoryId": self.catId,
                    "ComapnyId": 0,
                    "CityId": self.cityId,
                    "EventTypeId": self.eventTypeId,
                    "SearchText": self.searchTF.text ?? "",
                    "PageSize": 10,
                    "PageNumber": page + 1,
                    ]
                
                print(parameters)
                
                Alamofire.request(EVENTS_URL , method : .post, parameters :
                    parameters , encoding: JSONEncoding.default).responseJSON { response in
                        // print("Request: \(String(describing: response.request))")   // original url request
                        // print("Response: \(String(describing: response.response))") // http url response
                        // print("Result: \(response.result)")                         // response serialization result
                        switch response.result{
                        case .success:
                            if let json = response.result.value {                                //   print(json)
                                let eventData = Mapper<EventsData>().map(JSONObject: json)
                                if let list = eventData?.result?.Items{
                                    //self.eventsList = list
                                    onComplete(list)
                                    return
                                }
                            }
                            break
                        case .failure(let error):
                            onComplete([])
                            displayToastMessage(error.localizedDescription)
                            break
                        }
                }
                return
            }
            
            let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.eventsList.count ?
                (page + 1) * self.numberOfItemsPerPage : self.eventsList.count
            onComplete(Array(self.eventsList[firstIndex ..< lastIndex]))
           
        }
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
        
        menuVC.eventCountsData = eventcountsData
        menuVC.eventVC = self
        
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_obj: self.eventsList[indexPath.row])
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        var contentRect = CGRect.zero
        for view: UIView in self.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        prentview_height.constant = tableView.contentSize.height + 50
        //   contentRect.size.height = contentRect.size.height + 100
        //  scrollView.contentSize = contentRect.size
        print(tableView.contentSize.height)
        //print(contentRect.size.height)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width , height: tableView.contentSize.height + 100)
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        events_ptv.isLoading = true
        loadData(at: page) { contents in
            self.eventsList.append(contentsOf: contents)
            self.events_ptv.isLoading = false
            self.events_ptv.reloadData()
           
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as! EventsDetailsVC
        
        eventDetailsVC.eventObj = eventsList[indexPath.row]
        navigationController?.pushViewController(eventDetailsVC, animated: true)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllAdsVC"{
//            let vc = segue.destination as! AllAdsVC
//            vc.adsData = self.adsData
//            vc.selctedBarIndex = selctedBarIndex
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    func getEventsStatistics(){
        let parameters: Parameters = [
            "EventTo": 0,
            "Lang":Locale.preferredLanguages[0]
        ]
        
        Alamofire.request(EVENTS_COUNTS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                          // print(json)
                        let eventCountData = Mapper<EventCountsData>().map(JSONObject: json)
                        eventcountsData = (eventCountData?.result)!
                        
                        
                        self.options_img.isUserInteractionEnabled = true
                        let gestureSwift2AndHigher3 = UITapGestureRecognizer(
                            target: self, action:  #selector (self.navigateToSearchScreen(_:)))
                        self.options_img.addGestureRecognizer(gestureSwift2AndHigher3)
//                        let home = Bundle.main.localizedString(forKey: "home-menu", value: nil, table: "Default")
//                        let special = Bundle.main.localizedString(forKey: "special-ads", value: nil, table: "Default")
//                        let video = Bundle.main.localizedString(forKey: "video-ads", value: nil, table: "Default")
//                        let photo = Bundle.main.localizedString(forKey: "photo-ads", value: nil, table: "Default")
//                        let text = Bundle.main.localizedString(forKey: "text-ads", value: nil, table: "Default")
//                        //
//                        let imagesList = ["Home-Icon.png" , "Special-Ads-Icon.png","pic-ads-Icon.png", "Video-Ads-Icon.png", "Text-Ads-Icon.png"]
//                        
//                        let keyLsit = [home , special, photo, video, text]
//                        let countList = [adsStatData?.result?.AllAds ,
//                                         adsStatData?.result?.StarAdsCount,adsStatData?.result?.ImageAdsCount ,adsStatData?.result?.VedioAdsCount,
//                                         adsStatData?.result?.TextAdsCount]
//                        
//                        for i in 0 ..< 5 {
//                            let obj = AdsStatisticsClass(_name: keyLsit[i], _img: imagesList[i]
//                                , _count: countList[i]!)
//                            countData.append(obj)
//                        }
                        
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
