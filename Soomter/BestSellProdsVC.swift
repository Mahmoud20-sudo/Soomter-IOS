//
//  BestProdsVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class BestSellProdsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    
    @IBOutlet weak var options_img: UIImageView!
    @IBOutlet weak var search_img: UIImageView!
    @IBOutlet weak var search_container: UIView!
    
    @IBOutlet weak var best_selling_cv: UICollectionView!
    
    @IBOutlet weak var more_cv: UICollectionView!
    @IBOutlet weak var best_trades_cv: UICollectionView!
    var bestSellingProducts : [BestProductsData.Result] = []
    
    var isMore = false
    
    var productTradmarksData : [ProductTradmarksData.Result] = []
    
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
        
        if Locale.preferredLanguages[0] == "en"{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        else{
             bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        menu_btn.isEnabled = false
        
        print(bestSellingProducts.count)
        
        if bestSellingProducts.count > 0 {
            best_selling_cv.isHidden = false
            best_selling_cv.delegate = self
            best_selling_cv.dataSource = self
            
            best_selling_cv.isScrollEnabled = false
        }
        else if productTradmarksData.count > 0 {
            if isMore{
                more_cv.isHidden = false
                more_cv.delegate = self
                more_cv.dataSource = self

            }else{
                best_trades_cv.isHidden = false
                best_trades_cv.delegate = self
                best_trades_cv.dataSource = self
            }
        }
        
        search_container.roundedWithBorder(radius: 15)
        // Do any additional setup after loading the view.
        options_img.image = options_img.image!.withRenderingMode(.alwaysTemplate)
        options_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        search_img.image = search_img.image!.withRenderingMode(.alwaysTemplate)
        search_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        // Do any additional setup after loading the view.
        if Locale.preferredLanguages[0] != "en"{
            search_img.transform = search_img.transform.rotated(by: CGFloat(Double.pi / 2))
            //            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllAdsVC"{
            let vc = segue.destination as! AllAdsVC
            //vc.adsData = self.adsData
            //vc.selctedBarIndex = selctedBarIndex
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menubtn_clk(_ sender: UIButton) {
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//         let padding: CGFloat =  25
//            let collectionViewSize = collectionView.frame.size.width - padding
//            return CGSize(width: collectionViewSize/2, height: collectionViewSize/1.1)
//         }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == best_selling_cv
        {
            let cell: BestSellProdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellProdsCell", for: indexPath) as! BestSellProdsCell
            
            cell.config(_obj: bestSellingProducts[indexPath.row])
            cell.roundedWithBorder(radius: 5)
            
            
            return cell
            
        }
        else{
            let cell: ProdTradMarksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdTradMarksCell", for: indexPath) as! ProdTradMarksCell
            
            cell.config(_obj: productTradmarksData[indexPath.row])
            cell.roundedWithBorder(radius: 5)
            
            return cell
            
        }
        
        var frame = collectionView.frame
        frame.size.height = collectionView.contentSize.height
        collectionView.frame = frame

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == best_selling_cv
        {
            return bestSellingProducts.count
        }
        else {
            return productTradmarksData.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == best_selling_cv
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
            "ProductDetailsVC") as! ProductDetailsVC
            navigationController?.pushViewController(vc,
                                                 animated: true)
        }
    }

}
