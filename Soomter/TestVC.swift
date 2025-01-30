//
//  TestVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/20/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PagingTableView
import SideMenu

class TestVC: UIViewController , PagingTableViewDelegate, UITableViewDataSource , UITableViewDelegate{

    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    
    @IBOutlet weak var deleteall_btn: UIButton!
    @IBOutlet weak var deleteall_lbl: UILabel!
    
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var noficitation_ptv: PagingTableView!
    
    @IBOutlet weak var progressView: MSProgressView!
    
    var list : [NotificationsData.Items] = []
    
    var user = User()
    
    override func viewDidAppear(_ animated: Bool) {
//        self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1450
//        )
        
    }
//    override func viewWillLayoutSubviews(){
//        super.viewWillLayoutSubviews()
//        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 1450)
//    }
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
        menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 5, height: 1), radius: 5, scale: true)
        
        menu_btn.isHidden = true
        bck_btn.isHidden = true
        
        self.deleteall_btn.isHidden = true
        self.deleteall_lbl.isHidden = true
        
        if Locale.preferredLanguages[0] == "en"{
            // bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            menu_view.semanticContentAttribute = .forceRightToLeft
        }
        else{
            menu_view.semanticContentAttribute = .forceLeftToRight
        }
        menu_btn.isEnabled = false
        
        
        noficitation_ptv.dataSource = self
        noficitation_ptv.pagingDelegate = self
        noficitation_ptv.delegate = self
        
        self.progressView.isHidden = true
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            if let currentUser = Mapper<User>().map(JSONObject: recovedUserJson){
                user = currentUser
            }
            
        }
        
    }
    
    func deleteAll(){
        let parameters: Parameters = [
            "UserId": user.result!.id ?? ""
        ]
        
        print(parameters)
        Alamofire.request(DELETE_ALL_NOTIFS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value{
                        //f
                        print(json)
                        self.list = []
                        self.noficitation_ptv.reloadData()
                        
                        self.deleteall_btn.isHidden = true
                        self.deleteall_lbl.isHidden = true
                        displayToastMessage(Bundle.main.localizedString(forKey: "process-sucess", value: nil, table: "Default"))
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    
    
    @IBAction func deleteallbtn_clk(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: Bundle.main.localizedString(forKey: "warning-title", value: nil, table: "Default"),
                                             message: Bundle.main.localizedString(forKey: "warning-msg", value: nil, table: "Default"), preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "ok", value: nil, table: "Default"), style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAll()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "cancel", value: nil, table: "Default"), style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)

    }

    @IBAction func menubtn_clk(_ sender: UIButton) {
    }
    @IBAction func bckbnt_clk(_ sender: UIButton) {
        //if navigationController != nil {
             // }
        //else{
          //  exit(0)
        //}
        exit(0)
    }
    let numberOfItemsPerPage = 10
    
    func loadData(at page: Int, onComplete: @escaping ([NotificationsData.Items]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let firstIndex = page * self.numberOfItemsPerPage
            guard firstIndex < self.list.count else {
                let parameters: Parameters = [
                    "UserId": self.user.result!.id ?? "",
                    "PageSize": 10,
                    "PageNumber": page + 1
                ]
                
                Alamofire.request(NOTIFICATIONS_URL , method : .post, parameters :
                    parameters , encoding: JSONEncoding.default).responseJSON { response in
                        // print("Request: \(String(describing: response.request))")   // original url request
                        // print("Response: \(String(describing: response.response))") // http url response
                        // print("Result: \(response.result)")                         // response serialization result
                        switch response.result{
                        case .success:
                            if let json = response.result.value {                                //   print(json)
                                let eventData = Mapper<NotificationsData>().map(JSONObject: json)
                                if let list = eventData?.result?.Items{
                                    //self.eventsList = list.
                                    if let tabItems = self.tabBarController?.tabBar.items {
                                        // In this case we want to modify the badge number of the third tab:
                                        let tabItem = tabItems[2]
                                        if let number = eventData?.result?.TotalItemsCount{
                                            if number > 9 {
                                                tabItem.badgeValue = "9+"
                                            }
                                            else{
                                                tabItem.badgeValue = "\(number)"
                                            }
                                        }
                                    }
                                   // self.addRedDotAtTabBarItemIndex(index: 2)
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
            
            let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.list.count ?
                (page + 1) * self.numberOfItemsPerPage : self.list.count
            onComplete(Array(self.list[firstIndex ..< lastIndex]))
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NofticiationsCell", for: indexPath) as! NofticiationsCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_obj: self.list[indexPath.row])
        if Locale.preferredLanguages[0] == "en"{
            cell.container.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cell.container.semanticContentAttribute = .forceLeftToRight
            
        }
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: tableView.contentSize.height + 100)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        noficitation_ptv.isLoading = true
        loadData(at: page) { contents in
            self.list.append(contentsOf: contents)
            self.noficitation_ptv.isLoading = false
            if page == 1 && !self.list.isEmpty {
                self.deleteall_btn.isHidden = false
                self.deleteall_lbl.isHidden = false
            }
            if self.list.isEmpty{
                
                displayToastMessage(Bundle.main.localizedString(forKey: "no_result", value: nil, table: "Default"))
            }
            
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let eventDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationaCell") as! NofticiationsCell
    //
    //        eventDetailsVC.eventObj = eventsList[indexPath.row]
    //        navigationController?.pushViewController(eventDetailsVC, animated: true)
    //
    //    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllAdsVC"{
            //            let vc = segue.destination as! AllAdsVC
            //            vc.adsData = self.adsData
            //            vc.selctedBarIndex = selctedBarIndex
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    func addRedDotAtTabBarItemIndex(index: Int) {
        for subview in tabBarController!.tabBar.subviews {
            
            if let subview = subview as? UIView {
                
                if subview.tag == 1234 {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
        
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 2
        
        let TopMargin:CGFloat = 5
        
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        
        let screenSize = UIScreen.main.bounds
        let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
        
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] as! UITabBarItem).selectedImage!.size.width / 2
        
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth - 7, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        redDot.tag = 1234
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        
        self.tabBarController?.tabBar.addSubview(redDot)
        
    }
}
