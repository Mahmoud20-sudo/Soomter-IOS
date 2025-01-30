//
//  MainScreenVC.swift
//  Soomter
//
//  Created by Mahmoud on 11/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        
        if (tabBarIsVisible() == visible) { return }
        
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            }.startAnimation()
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}


class MainScreenVC: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var prent_view: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var middle_view: UIView!
    @IBOutlet weak var serch_btn: UIButton!
    @IBOutlet weak var catgs_container: UIView!
    @IBOutlet weak var catgs_layer: UIView!
    @IBOutlet weak var products_cotainer: UIView!
    @IBOutlet weak var products_layer: UIView!
    @IBOutlet weak var ads_container: UIView!
    @IBOutlet weak var ads_layer: UIView!
    @IBOutlet weak var events_container: UIView!
    @IBOutlet weak var events_layer: UIView!
    @IBOutlet weak var auctions_container: UIView!
    @IBOutlet weak var auctions_layer: UIView!
    @IBOutlet weak var tenders_container: UIView!
    @IBOutlet weak var tenders_layer: UIView!
    @IBOutlet weak var serch_icon: UIImageView!
    @IBOutlet weak var search_input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //        appDelegate.esTabController.tabBar.isHidden = false
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        scrollview.delegate = self
        serch_btn.roundedWithBorder(color:  "#D9B878" , radius: 10.0)
        middle_view.roundedWithBorder(color:  "#D9B878" , radius: 13.0)
        catgs_container.roundedWithBorder(radius: 5.0)
        catgs_layer.roundedWithBorder(radius: 5.0)
        products_cotainer.roundedWithBorder(radius: 5.0)
        products_layer.roundedWithBorder(radius: 5.0)
        ads_container.roundedWithBorder(radius: 5.0)
        ads_layer.roundedWithBorder(radius: 5.0)
        events_container.roundedWithBorder(radius: 5.0)
        events_layer.roundedWithBorder(radius: 5.0)
        auctions_container.roundedWithBorder(radius: 5.0)
        auctions_layer.roundedWithBorder(radius: 5.0)
        tenders_container.roundedWithBorder(radius: 5.0)
        tenders_layer.roundedWithBorder(radius: 5.0)
        
        let pre = Locale.preferredLanguages[0]
        
        if pre != "en"{
            serch_btn.titleEdgeInsets = UIEdgeInsetsMake(-5,0,0,0)
            serch_icon.transform = serch_icon.transform.rotated(by: CGFloat(Double.pi / 2))
            prent_view.semanticContentAttribute = .forceRightToLeft
            
        }
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToRegScreen(_:)))
        catgs_container.addGestureRecognizer(gestureSwift2AndHigher)
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToAdsScreen(_:)))
        ads_container.addGestureRecognizer(gestureSwift2AndHigher2)
        
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToEventsScreen(_:)))
        events_container.addGestureRecognizer(gestureSwift2AndHigher3)
        
        let gestureSwift2AndHigher4 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToProdsScreen(_:)))
        products_cotainer.addGestureRecognizer(gestureSwift2AndHigher4)
        
        let gestureSwift2AndHigher5 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToTendersScreen(_:)))
        tenders_container.addGestureRecognizer(gestureSwift2AndHigher5)
        
        let gestureSwift2AndHigher6 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToAuctionsScreen(_:)))
        auctions_container.addGestureRecognizer(gestureSwift2AndHigher6)

        if UserDefaults.standard.object(forKey: "PortalBussinsCatgsData") != nil
            
        {
            //print(recovedUserJsonData2)
        }else{
            getPortalBussCatgs( completionHandler: { (success) -> Void in
                // When download completes,control flow goes here.
                if success {
                    // download success
                } else {
                    // download fail
                }
                
            })
            
        }
        
        if UserDefaults.standard.object(forKey: "PortalBussinsCatgsData") != nil
        {
            // print(recovedUserJsonData)
            
        }else{
            getPortalBussCatgs( completionHandler: { (success) -> Void in
                // When download completes,control flow goes here.
                if success {
                    // download success
                    
                } else {
                    // download fail
                }
            })
            
        }
        if UserDefaults.standard.object(forKey: "CITIES") != nil
        {            //print(recovedUserJsonData)
            
        }else{
            
            getCities( completionHandler: { (success) -> Void in
                
                // When download completes,control flow goes here.
                
                if success {
                    
                    // download success
                    
                } else {
                    
                    // download fail
                    
                }
                
            })
            
        }
        
        
        
        if UserDefaults.standard.object(forKey: "PRODS_CATGS") != nil
            
        {
            
            //print(recovedUserJsonData)
            
        }else{
            
            getProdsCatgsTree( completionHandler: { (success) -> Void in
                
                // When download completes,control flow goes here.
                
                if success {
                    
                    // download success
                    
                } else {
                    
                    // download fail
                    
                }
                
            })
            
        }
        
        
        
        search_input.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        
    }
    
    
    @IBAction func searchbtn_clk(_ sender: UIButton) {
        search_input.resignFirstResponder()
        
        if search_input.text?.count == 0 {
            Bundle.main.localizedString(forKey: "fill-rq-field", value: nil, table: "Default")
            return
        }
        
        if let text = search_input.text{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier:
                
                "CompaniesVC") as! CompaniesVC
            
            navigationController?.pushViewController(vc,
                                                     
                                                     animated: true)
            
            vc.searchTxt = text
            
        }
        
    }
    
    func enterPressed(){
        
        //do something with typed text if needed
        
        search_input.resignFirstResponder()
        
        if search_input.text?.count == 0 {
            Bundle.main.localizedString(forKey: "fill-rq-field", value: nil, table: "Default")
            return
        }

        
        if let text = search_input.text{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier:
                
                "CompaniesVC") as! CompaniesVC
            
            navigationController?.pushViewController(vc,
                                                     
                                                     animated: true)
            
            vc.searchTxt = text
            
        }
        
        
        
    }
    
    
    
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 900)
    }
    
    
    
    func navigateToAuctionsScreen(_ sender:UITapGestureRecognizer)  {
        
        let home = Bundle.main.localizedString(forKey: "not-added", value: nil, table: "Default")
        
        displayToastMessage(home)
        
    }
    
    
    
    func navigateToTendersScreen(_ sender:UITapGestureRecognizer)  {
        
        
        
        let home = Bundle.main.localizedString(forKey: "not-added", value: nil, table: "Default")
        
        displayToastMessage(home)
        
        
        
    }
    
    
    
    
    
    
    
    func navigateToProdsScreen(_ sender:UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier:
            
            "ProductsMainVC") as! ProductsMainVC
        
        navigationController?.pushViewController(vc,
                                                 
                                                 animated: true)
        
    }
    
    
    
    func navigateToRegScreen(_ sender:UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier:
            
            "CatgsVC") as! CatgsVC
        
        navigationController?.pushViewController(vc,
                                                 
                                                 animated: true)
        
    }
    
    
    
    func navigateToEventsScreen(_ sender:UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier:
            
            "EventsVC") as! EventsVC
        
        navigationController?.pushViewController(vc,
                                                 
                                                 animated: true)
        
    }
    
    
    
    func navigateToAdsScreen(_ sender:UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier:
            
            "MainAdsVC") as! MainAdsVC
        
        navigationController?.pushViewController(vc,
                                                 
                                                 animated: true)
        
    }
    
    
    
    @IBAction func serchbtn_clk(_ sender: UIButton) {
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            
            //self.changeTabBar(hidden: true, animated: true)
            
            self.tabBarController?.setTabBarVisible(visible: false, duration: 0.1, animated: true)
            
            
            
        }
            
        else{
            
            // self.changeTabBar(hidden: false, animated: true)
            
            self.tabBarController?.setTabBarVisible(visible: true, duration: 0.1, animated: true)
            
            
            
        }
        
    }
    
    
    
    
    
    func changeTabBar(hidden:Bool, animated: Bool){
        
        let tabBar = self.tabBarController?.tabBar
        
        if tabBar?.isHidden == hidden{ return }
        
        if let frame = tabBar?.frame{
            
            let offset = (hidden ? (frame.size.height) : -(frame.size.height))
            
            let duration:TimeInterval = (animated ? 0.5 : 0.0)
            
            tabBar?.isHidden = false
            
            UIView.animate(withDuration: duration,
                           
                           animations: {tabBar?.frame = frame.offsetBy(dx: 0, dy: offset)},
                           
                           completion: {
                            
                            //println($0)
                            
                            if $0 {tabBar?.isHidden = hidden}})
            
        }
        
    }
    
}

