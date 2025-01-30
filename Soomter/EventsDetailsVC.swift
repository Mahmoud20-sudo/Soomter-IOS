//  EventsDetailsVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/19/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SideMenu
import MapKit
import ESTabBarController_swift
import JGProgressHUD
import AVFoundation

import MediaPlayer

class EventsDetailsVC: UIViewController , UITableViewDataSource, UITableViewDelegate , UITextViewDelegate , UICollectionViewDelegate, UIScrollViewDelegate,           UICollectionViewDataSource{

    @IBOutlet weak var prentview_height: NSLayoutConstraint!
    
    @IBOutlet weak var stck_view: UIStackView!
    @IBOutlet weak var event_Time_view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var menu_btn: UIButton!
    
    @IBOutlet weak var top_view: UIView!
    @IBOutlet weak var top_tableview: UITableView!
    @IBOutlet weak var event_catg_lbl: UILabel!
    @IBOutlet weak var event_name_lbl: UILabel!
    @IBOutlet weak var event_time_lbl: UILabel!
    @IBOutlet weak var top_tableview_height: NSLayoutConstraint!
    @IBOutlet weak var event_img: UIImageView!
    @IBOutlet weak var fav_img: UIImageView!
    
    @IBOutlet weak var description_view: UIView!
    @IBOutlet weak var description_textview: UITextView!
    @IBOutlet weak var description_view_height: NSLayoutConstraint!
    @IBOutlet weak var description_textview_height: NSLayoutConstraint!
    
    @IBOutlet weak var details_btn: UIButton!
    @IBOutlet weak var location_btn: UIButton!
    @IBOutlet weak var organizers_btn: UIButton!
    
    @IBOutlet weak var details_view: UIView!
    @IBOutlet weak var location_view: UIView!
    @IBOutlet weak var organizers_view: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reg_btn: UIButton!
    @IBOutlet weak var invite_btn: UIButton!
    @IBOutlet weak var bottom_tableview: UITableView!
    @IBOutlet weak var bottom_tableview_height: NSLayoutConstraint!

    
    @IBOutlet weak var organizers_cv: UICollectionView!
    
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var fav_lbl: UILabel!
    
    @IBOutlet weak var esTabBar: ESTabBar!
    
    
    var tabBar: ESTabBar = ESTabBar()
    
    var informationsList : [String] = []
    var informationsImgList : [String] = []
    
    var orgnizersList : [EventDetailsData.Organizers] = []
    
    var detailsList : [Informations] = []
    
    var eventObj : EventsData.Items!
    var hud : JGProgressHUD!
    
    let annotation = MKPointAnnotation()
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
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
//        let v1 = TestVC()
//        let v2 = TestVC()
//        let v3 = TestVC()
//        let v4 = TestVC()
//        let v5 = TestVC()
//    
//        
//        v1.tabBarItem = ESTabBarItem.init(title: "الرئيسية", image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
//        v2.tabBarItem = ESTabBarItem.init(title: "Find", image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
//        v3.tabBarItem = ESTabBarItem.init(title: "Photo", image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
//        v4.tabBarItem = ESTabBarItem.init(title: "Favor", image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
//        v5.tabBarItem = ESTabBarItem.init(title: "Me", image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
//        
//        tabBar.shadowImage = nil
//        
//        let tabController = ESTabBarController()
//        tabController.viewControllers = [v1,v2,v3,v4,v5]
//        tabController.selectedIndex = 0
//        
//        tabController.tabBar.backgroundColor = UIColor.black
//        
//        self.view.window?.rootViewController = tabController
//        self.view.window?.makeKeyAndVisible()
        
        centerMapOnLocation(location: initialLocation)
        annotation.coordinate = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
        mapView.addAnnotation(annotation)
        
        mapView.roundedWithBorder(radius: 8)
        
        menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 5, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] != "en"{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        //menu_btn.isEnabled = false
        // Do any additional setup after loading the view.
        top_view.roundedWithBorder(radius: 8)
        description_view.roundedWithBorder(radius: 8)
        details_btn.roundedWithBorder(radius: 8)
        location_btn.roundedWithBorder(radius: 8)
        organizers_btn.roundedWithBorder(radius: 8)
        
        bottom_tableview.roundedWithBorder(radius: 8)
        reg_btn.roundedWithBorder(radius: 15)
        invite_btn.roundedWithBorder(radius: 15)
        
        details_btn.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if eventObj.IsStar! {
            fav_img.isHidden = false
        }
        
        if let img =  URL(string: eventObj.Image!){
            self.event_img.kf.setImage(with: img,
                                       placeholder: nil,
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil,
                                       completionHandler: nil)
        }
        description_textview.textContainer.maximumNumberOfLines = 12
        description_textview.textContainer.lineBreakMode = .byTruncatingTail
        
        top_tableview.delegate = self
        top_tableview.dataSource = self
        bottom_tableview.delegate = self
        bottom_tableview.dataSource = self
        
        description_textview.delegate = self
        
        organizers_cv.delegate = self
        organizers_cv.dataSource = self
        
        scrollView.delegate = self
        
        getEveDetails()
        
        fav_btn.isUserInteractionEnabled = true
        fav_lbl.isUserInteractionEnabled = true
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToFavScreen(_:)))
        fav_lbl.addGestureRecognizer(gestureSwift2AndHigher2)

        self.scrollView.isScrollEnabled = true
        
        if Locale.preferredLanguages[0] == "en"{
            menu_view.semanticContentAttribute = .forceRightToLeft
            event_Time_view.semanticContentAttribute = .forceRightToLeft
            stck_view.semanticContentAttribute = .forceRightToLeft
        }
        else{
            description_view.semanticContentAttribute = .forceLeftToRight
            menu_view.semanticContentAttribute = .forceLeftToRight
            event_Time_view.semanticContentAttribute = .forceLeftToRight
            stck_view.semanticContentAttribute = .forceLeftToRight
        }
        
        prentview_height.constant = 1130
        self.view.layoutIfNeeded()
        
    
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width , height: 1500)
//       self.view.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: 1130)
        scrollView.isUserInteractionEnabled = true;
        scrollView.isExclusiveTouch = true;

        scrollView.canCancelContentTouches = true;
        scrollView.delaysContentTouches = true;

        
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

    
    override func viewDidAppear(_ animated: Bool) {
       // self.scrollView.contentSize = CGSize(width : scrollView.contentSize.width , height: 1450)
        
    }
    @IBAction func location_btn_clk(_ sender: UIButton) {
        clearSelections()
        location_btn.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        location_btn.setTitleColor(hexStringToUIColor(hex: "#333132"), for: .normal)
        location_view.isHidden = false

    }
    @IBAction func details_btn_clk(_ sender: UIButton) {
        clearSelections()
        details_btn.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        details_btn.setTitleColor(hexStringToUIColor(hex: "#333132"), for: .normal)
        details_view.isHidden = false
    }
    @IBAction func organizers_btn_clk(_ sender: UIButton) {
        clearSelections()
        organizers_btn.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        organizers_btn.setTitleColor(hexStringToUIColor(hex: "#333132"), for: .normal)
        organizers_view.isHidden = false

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == top_tableview{
            return informationsList.count
        }
        else{
            return detailsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == top_tableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfromationsCell", for: indexPath) as! InfromationsCell
        
            cell.config(_name: self.informationsList[indexPath.row], _img: self.informationsImgList[indexPath.row])
        
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDataCell", for: indexPath) as! EventDataCell
            
            cell.config(_obj: detailsList[indexPath.row])
            
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == top_tableview{
            top_tableview_height.constant = tableView.contentSize.height
            top_tableview.layoutIfNeeded()
        }
        else{
            bottom_tableview_height.constant = tableView.contentSize.height
            bottom_tableview.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProdTradMarksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdTradMarksCell", for: indexPath) as! ProdTradMarksCell
        
        cell.config2(_obj: orgnizersList[indexPath.row])
        cell.roundedWithBorder(radius: 8)
        
        var frame = collectionView.frame
        frame.size.height = collectionView.contentSize.height
        collectionView.frame = frame
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
//            let cellWidth = (organizers_view.frame.width - max(0, 1 - 1)*horizontalSpacing)/3.2
//            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
//        }
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var collectionViewSize = collectionView.frame.size
            //collectionViewSize.width = collectionViewSize.width/2.0 //Display Three elements in a row.
            //collectionViewSize.height = collectionViewSize.height/4.0
             flowLayout.itemSize = CGSize(width:  collectionViewSize.width/2.1, height: collectionViewSize.height/3)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orgnizersList.count
    }
    
    func clearSelections(){
        details_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        location_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        organizers_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        organizers_btn.setTitleColor(hexStringToUIColor(hex: "#C9CACB"), for: .normal)
        location_btn.setTitleColor(hexStringToUIColor(hex: "#C9CACB"), for: .normal)
        details_btn.setTitleColor(hexStringToUIColor(hex: "#C9CACB"), for: .normal)
        
        details_view.isHidden = true
        location_view.isHidden = true
        organizers_view.isHidden = true
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
    
    func getEveDetails(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Id": eventObj.Id
        ]
        
        Alamofire.request(EVENTS_DETAILS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                self.hud.dismiss()
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let eventData = Mapper<EventDetailsData>().map(JSONObject: json)
                        self.event_name_lbl.text = eventData?.result?.Title
                        if let catg = eventData?.result?.Category {
                            self.event_catg_lbl.text = Bundle.main.localizedString(forKey: "home-menu", value: nil, table: "Default") + "("
                                + catg + ")"
                        }
                        if let hijriFrom =  eventData?.result?.HigriFromDate {
                            self.informationsList.append(hijriFrom)
                            //"Calender-Icon.png","Calender-Icon.png", "Clock-Icon.png", "Location-Icon.png"
                            self.informationsImgList.append("Calender-Icon.png")
                        }
                        
                        if let hijriTo =  eventData?.result?.HigriToDate {
                            self.informationsList.append(hijriTo)
                            self.informationsImgList.append("Calender-Icon.png")
                        }
                        
                        if let hijriTo =  eventData?.result?.HigriToDate {
                            self.informationsList.append(hijriTo)
                            self.informationsImgList.append("Calender-Icon.png")
                        }
                        
                        
                        if let timeFrom =  eventData?.result?.timeFrom {
                            let toDate = (eventData?.result?.timeTo != nil) ? Bundle.main.localizedString(forKey: "to", value: nil, table: "Default") + (eventData?.result?.timeTo)! : ""
                            
                            self.informationsList.append(Bundle.main.localizedString(forKey: "from", value: nil, table: "Default") + timeFrom + toDate)
                            
                            self.informationsImgList.append("Clock-Icon.png")
                        }
                        
                        if let location =  eventData?.result?.Location {
                            self.informationsList.append(location)
                            self.informationsImgList.append("Location-Icon.png")
                        }
                        self.top_tableview.reloadData()
                
                        switch eventData?.result?.Status{
                        case 0?:
                            self.event_time_lbl.text = Bundle.main.localizedString(forKey: "done", value: nil, table: "Default")
                            
                        case 1?:
                            self.event_time_lbl.text = Bundle.main.localizedString(forKey: "soon", value: nil, table: "Default")
                            
                        case 2?:
                            self.event_time_lbl.text = Bundle.main.localizedString(forKey: "nw", value: nil, table: "Default")
                            
                        default:
                            self.event_time_lbl.text = ""
                        }
                        
                        if let latitude = eventData?.result?.Lat , let longitude = eventData?.result?.Long{
                            
                            self.centerMapOnLocation(location: CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!))
                            self.annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                            self.mapView.addAnnotation(self.annotation)
                        }
                        
                        self.description_textview.delegate = self
                        
                        if let desc = eventData?.result?.Details {
                            self.description_textview.text = desc
                            
                                self.description_textview_height.constant = self.description_textview.contentSize.height
                                print(self.description_textview.contentSize.height)
                                self.description_view_height.constant = self.description_textview.contentSize.height
                            
                            //                            var frame = self.description_textview.frame
                            //                            frame.size.height = self.description_textview.contentSize.height
                            //                            self.description_textview.frame = frame
                            //
                            //                            var frame2 = self.description_view.frame
                            //                            frame2.size.height = self.description_textview.contentSize.height
                            //                            self.description_view.frame = frame2
                            
                            self.description_view.layoutIfNeeded()
                            self.description_textview.layoutIfNeeded()
                            self.view.layoutIfNeeded()

                        }
                        
                        if let phone =  eventData?.result?.Telephone {
                            self.detailsList.append(Informations(title: phone, value: "Phone-Icon"))
                        }
                        if let mob =  eventData?.result?.Mobile {
                            self.detailsList.append(Informations(title: mob, value: "Mobile-Icon"))
                        }
                        if let mail =  eventData?.result?.Email {
                            self.detailsList.append(Informations(title: mail, value: "Mail-Icon"))
                        }
                        if let site =  eventData?.result?.Link {
                            self.detailsList.append(Informations(title: site, value: "Website-Icon"))
                        }
                        self.bottom_tableview.reloadData()
                        
                        self.orgnizersList = (eventData?.result?.Organizers)!
                    
                        self.organizers_cv.reloadData()
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            self.changeTabBar(hidden: true, animated: true)
        }
        else{
            self.changeTabBar(hidden: false, animated: true)
        }
    }

    func changeTabBar(hidden:Bool, animated: Bool){
       /// var tabBar = self.tabBarController?.tabBar
//        if tabBar.tabBar.isHidden == hidden{ return }
//        let frame = tabBar.tabBar.frame
//        let offset = (hidden ? (frame.size.height) : -(frame.size.height))
//        let duration:TimeInterval = (animated ? 0.5 : 0.0)
//        tabBar.tabBar.isHidden = false
//        if frame != nil
//        {
//            UIView.animate(withDuration: duration,
//                                       animations: {self.tabBar.tabBar.frame = frame.offsetBy(dx: 0, dy: offset)},
//                                       completion: {
//                                        //println($0)
//                                        if $0 {self.tabBar.tabBar.isHidden = hidden}
//            })
//        }
    }
}
