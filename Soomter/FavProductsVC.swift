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
import ObjectMapper

class FavProductsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    
    @IBOutlet weak var options_img: UIImageView!
    @IBOutlet weak var search_img: UIImageView!
    @IBOutlet weak var search_container: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var best_selling_cv: UICollectionView!
    
    @IBOutlet weak var progressView: MSProgressView!
    
    @IBOutlet weak var more_cv: UICollectionView!
    @IBOutlet weak var best_trades_cv: UICollectionView!
    var bestSellingProducts : [BestProductsData.Result] = []
    
    var isMore = false
    var isFavourite = 0
    
    
    @IBOutlet weak var scroll_view: UIScrollView!
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
        
        print(Locale.preferredLanguages[0])
        
        menu_btn.isEnabled = false
        
        progressView.start()
        progressView.start(automaticallyShow: true)
        progressView.setBar(color:UIColor.black, animated:true)
        
        
        print(bestSellingProducts.count)
        
      //  if bestSellingProducts.count > 0 {
            best_selling_cv.delegate = self
            best_selling_cv.dataSource = self
            
            best_selling_cv.isScrollEnabled = false
       // }
        
        search_container.roundedWithBorder(radius: 15)
        // Do any additional setup after loading the view.
        options_img.image = options_img.image!.withRenderingMode(.alwaysTemplate)
        options_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        search_img.image = search_img.image!.withRenderingMode(.alwaysTemplate)
        search_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        // Do any additional setup after loading the view.
        if Locale.preferredLanguages[0] != "en"{
            search_img.transform = search_img.transform.rotated(by: CGFloat(Double.pi / 2))
               bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            user = Mapper<User>().map(JSONObject: recovedUserJson)
           
            if let loggedUSer = user {
                print(loggedUSer.result!.userType!)
                if (loggedUSer.result!.userType! != "Company") {
                    userID = loggedUSer.result!.id!
                    ProductTo = 1;
                } else
                {
                    ProductTo = 2;
                }
            }
            
        }
        searchTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        searchTF.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        
        if !searchTxt.isEmpty{
            searchTF.text = searchTxt
            let msg = Bundle.main.localizedString(forKey: "serch_result", value: nil, table: "Default")
            title_lbl.text = msg
        }
        
        getProducts()
        
    }
    var user : User?
    var userID = ""
    var ProductTo = 1
    var searchTxt = ""
    
    func enterPressed(){
        //do something with typed text if needed
        searchTF.resignFirstResponder()
        if let text = searchTF.text{
            searchTxt = text
            getProducts()
        }
    }
    
    func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            searchTxt = ""
            getProducts()
        }
    }
    
    func getProducts(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Title": searchTxt,
            "CategoryId": 0,
            "ProductTo": 1,
            "MinPrice": 0,
            "MaxPrice": 0,
            "CurrentUserId": userID,
            "IsFavourit": isFavourite,
            "TradeMarkIds": "",
        ]
        
        print(parameters)
        Alamofire.request(GET_PRODUCTS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        self.progressView.isHidden = true
                        self.best_selling_cv.isHidden = false
                        let bestProductsData = Mapper<BestProductsData>().map(JSONObject: json)
                        self.bestSellingProducts = (bestProductsData?.result)!
                        print(self.bestSellingProducts)
                        
                        self.best_selling_cv.reloadData()
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    self.progressView.isHidden = true
                    self.best_selling_cv.isHidden = false
                    displayToastMessage(error.localizedDescription)
                    break
                }
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
            let cell: BestSellProdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellProdsCell", for: indexPath) as! BestSellProdsCell
            
            cell.config(_obj: bestSellingProducts[indexPath.row])
            cell.roundedWithBorder(radius: 5)
        
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return bestSellingProducts.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == best_selling_cv
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "ProductDetailsVC") as! ProductDetailsVC
            vc.productObj = bestSellingProducts[indexPath.row]
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
    }
    
}
