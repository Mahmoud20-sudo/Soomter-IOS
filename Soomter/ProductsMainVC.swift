//
//  ProductsMainVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SideMenu

class ProductsMainVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource
{

    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    
    
    @IBOutlet weak var options_img: UIImageView!
    @IBOutlet weak var search_img: UIImageView!
    @IBOutlet weak var search_container: UIView!
    
    @IBOutlet weak var bes_selling_progress: MSProgressView!
    @IBOutlet weak var best_selling_cv: UICollectionView!
    
    @IBOutlet weak var best_treades_progress: MSProgressView!
    @IBOutlet weak var best_trades_cv: UICollectionView!
    
    @IBOutlet weak var more_progress: MSProgressView!
    @IBOutlet weak var more_cv: UICollectionView!
    
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var fav_lbl: UILabel!
    
    @IBOutlet weak var bestsell_btn: UIButton!
    @IBOutlet weak var besttrades_btn: UIButton!
    @IBOutlet weak var more_btn: UIButton!
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var first_view: UIView!
    @IBOutlet weak var middle_view: UIView!
    @IBOutlet weak var bottom_view: UIView!
    
    var bestSellingProducts : [BestProductsData.Result] = []
    
    var productTradmarksData : [ProductTradmarksData.Result] = []
    
    var moreProds : [ProductTradmarksData.Result] = []
    
    var catgsList : [ProductCatgsTreeData.Result] = []
    
    @IBOutlet weak var cart_lbl: UILabel!
    
    @IBAction func cartbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let curentUser = user{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier:
                    "CartVC") as! CartVC
                vc.user = curentUser
                navigationController?.pushViewController(vc,
                                                         animated: true)
            }
            else{
                let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
                displayToastMessage(msg)
                return
            }
        }else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }
    
    func navToCartScreen(_ sender:UITapGestureRecognizer)  {
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let curentUser = user{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier:
                    "CartVC") as! CartVC
                vc.user = curentUser
                navigationController?.pushViewController(vc,
                                                         animated: true)
            }
            else{
                let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
                displayToastMessage(msg)
                return
            }
        }else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }
    
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
        
        menu_btn.isEnabled = false
        bestsell_btn.isEnabled = false
        besttrades_btn.isEnabled = false
        more_btn.isEnabled = false
        
        best_selling_cv.delegate = self
        best_selling_cv.dataSource = self
        
        best_trades_cv.delegate = self
        best_trades_cv.dataSource = self
        
        more_cv.delegate = self
        more_cv.dataSource = self
        
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
        prepareProg(view: bes_selling_progress)
         prepareProg(view: best_treades_progress)
         prepareProg(view: more_progress)
        
        getBestSellingProducts()
        getTradeMarks()
        getMoreProds()
        
        if let recovedUserJsonData2 = UserDefaults.standard.object(forKey: "PRODS_CATGS")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData2 as! Data)
            let obj = Mapper<ProductCatgsTreeData>().map(JSONObject: recovedUserJson)!
            catgsList = obj.result!
            prepareSideMenu()
            
            //setCatgsData(portalCatsList: portalCatsList!)
            
        }else{
            getProdsCatgsTree( completionHandler: { (success) -> Void in
                // When download comp
                if success {
                    // download success
                    let recovedUserJson = NSKeyedUnarchiver     .unarchiveObject(with: UserDefaults.standard.object(forKey: "PRODS_CATGS") as! Data)
                    let obj = Mapper<ProductCatgsTreeData>().map(JSONObject: recovedUserJson)!
                    self.catgsList = obj.result!
                    
                    self.prepareSideMenu()
                }
            })
        }
        
        searchTF.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        
        
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
        cart_lbl.isUserInteractionEnabled = true
        fav_lbl.isUserInteractionEnabled = true
        
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToFavScreen(_:)))
        fav_lbl.addGestureRecognizer(gestureSwift2AndHigher3)
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navToCartScreen(_:)))
        cart_lbl.addGestureRecognizer(gestureSwift2AndHigher2)
        
       // view.addSubview(scrollview)
        if Locale.preferredLanguages[0] == "en"{
            menu_view.semanticContentAttribute = .forceRightToLeft
            //bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            first_view.semanticContentAttribute = .forceLeftToRight
            middle_view.semanticContentAttribute = .forceLeftToRight
            bottom_view.semanticContentAttribute = .forceLeftToRight
            best_selling_cv.semanticContentAttribute = .forceLeftToRight
            
        }
        else{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            menu_view.semanticContentAttribute = .forceLeftToRight
            first_view.semanticContentAttribute = .forceRightToLeft
            middle_view.semanticContentAttribute = .forceRightToLeft
            bottom_view.semanticContentAttribute = .forceRightToLeft
            best_selling_cv.semanticContentAttribute = .forceRightToLeft
        }
        self.scrollview.isScrollEnabled = true
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 800)
    }
    
    var searchTxt  = ""
    var user : User?
    var ProductTo = 1
    var userID = ""
    var tradeID = ""

    func enterPressed(){
        //do something with typed text if needed
        searchTF.resignFirstResponder()
        if let text = searchTF.text{
            searchTxt = text
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "FavProductsVC") as! FavProductsVC
            vc.searchTxt = text
            searchTF.text = ""
            navigationController?.pushViewController(vc,
                                                     animated: true)
            
        }
    }
    
    func getProducts(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Title": searchTxt,
            "CategoryId": 0,
            "ProductTo": ProductTo,
            "MinPrice": 0,
            "MaxPrice": 0,
            "CurrentUserId": userID,
            "IsFavourit": 0,
            "TradeMarkIds": tradeID,
            ]
        
        Alamofire.request(GET_PRODUCTS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let bestProductsData = Mapper<BestProductsData>().map(JSONObject: json)
                        if((bestProductsData?.result?.count)! == 0){
                            
                            displayToastMessage(Bundle.main.localizedString(forKey: "no_result", value: nil, table: "Default"))
                            return
                        }
                        self.bestSellingProducts = (bestProductsData?.result)!
                        self.best_selling_cv.reloadData()
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    
    @IBAction func favbtn_clk(_ sender: UIButton) {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User"){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "FavProductsVC") as! FavProductsVC
            vc.isFavourite = 1
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
                "FavProductsVC") as! FavProductsVC
            vc.isFavourite = 1
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
        }
    }
    
    func prepareProg(view : MSProgressView){
        view.start()
        view.start(automaticallyShow: true)
        view.setBar(color:UIColor.black, animated:true)
    }
    
    func prepareSideMenu(){
        
        menu_btn.isEnabled = true
        // Define the menus
        //let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: ViewController())
        //menuLeftNavigationController.leftSide = true
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "GroupedMenuVC") as! GroupedMenuVC
        
        menuVC.catgsList = catgsList
        
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

    func getBestSellingProducts(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Count": 30
        ]
        
        Alamofire.request(BEST_SELLING_PRODUCTS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                         print(json)
                        let bestProductsData = Mapper<BestProductsData>().map(JSONObject: json)
                        self.bestSellingProducts = (bestProductsData?.result)!
                        self.bes_selling_progress.isHidden = true
                        self.best_selling_cv.reloadData()
                        
                        self.bestsell_btn.isEnabled = true
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func getTradeMarks(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0]
        ]
        
        Alamofire.request(BEST_TRADEMARKS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let data = Mapper<ProductTradmarksData>().map(JSONObject: json)
                        self.productTradmarksData = (data?.result)!
                        self.best_treades_progress.isHidden = true
                        self.best_trades_cv.reloadData()
                        
                        self.besttrades_btn.isEnabled = true
//                        let padding: CGFloat =  25
//                        let collectionViewSize = self.best_trades_cv.frame.size.width - padding
//                        self.best_trades_cv.frame.size = CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    func getMoreProds(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0]
        ]
        
        Alamofire.request(BEST_CATGS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        print(json)
                        let data = Mapper<ProductTradmarksData>().map(JSONObject: json)
                        self.moreProds = (data?.result)!
                        self.more_progress.isHidden = true
                        self.more_cv.reloadData()
                        
                        self.more_btn.isEnabled = true
                        //                        let padding: CGFloat =  25
                        //                        let collectionViewSize = self.best_trades_cv.frame.size.width - padding
                        //                        self.best_trades_cv.frame.size = CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
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
            //vc.adsData = self.adsData
            //vc.selctedBarIndex = selctedBarIndex
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
    


    @IBAction func bckbtn_clk(_ sender: UIButton) {
        if navigationController != nil {
        navigationController!.popViewController(animated: true)
    }
    else{
        exit(0)
        }
    }
    
    @IBAction func menubtn_clk(_ sender: UIButton) {
        if Locale.preferredLanguages[0] == "en" {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }else{
            present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == best_selling_cv
        {
            let cell: BestSellProdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellProdsCell", for: indexPath) as! BestSellProdsCell
            if Locale.preferredLanguages[0] == "en"{
                cell.semanticContentAttribute = .forceRightToLeft
            }
            cell.config(_obj: bestSellingProducts[indexPath.row])
            cell.roundedWithBorder(radius: 5)
            
            return cell

        }
        else if collectionView == best_trades_cv{
            let cell: ProdTradMarksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdTradMarksCell", for: indexPath) as! ProdTradMarksCell
            
            cell.config(_obj: productTradmarksData[indexPath.row])
            cell.roundedWithBorder(radius: 5)
            
            return cell

        }
        else{//moreProds
            let cell: ProdTradMarksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdTradMarksCell", for: indexPath) as! ProdTradMarksCell
            
            cell.config(_obj: moreProds[indexPath.row])
            cell.roundedWithBorder(radius: 5)
            
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == best_selling_cv
        {
            return bestSellingProducts.count
        }
        else if collectionView == best_trades_cv{
            return productTradmarksData.count
        }
        else {
            return moreProds.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == best_selling_cv
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "ProductDetailsVC") as! ProductDetailsVC
            vc.productObj = bestSellingProducts[indexPath.row]
            navigationController?.pushViewController(vc,animated: true)
        }
        else if(collectionView == best_trades_cv){
            tradeID = productTradmarksData[indexPath.row].Id.map(String.init) ?? "" // "" defaultvalue in case 'a' is nil
            //bestSellingProducts = []
            //best_selling_cv.reloadData()
            getProducts()
        }
        else{
            tradeID = moreProds[indexPath.row].Id.map(String.init) ?? "" // "" defaultvalue in case 'a' is nil
            //bestSellingProducts = []
            //best_selling_cv.reloadData()
            getProducts()
        }
    }
    
    @IBAction func bestsellbtn_clk(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "BestSellProdsVC") as! BestSellProdsVC
        vc.bestSellingProducts = bestSellingProducts
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func besttradesbtn_clk(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "BestSellProdsVC") as! BestSellProdsVC
        vc.productTradmarksData = productTradmarksData
        navigationController?.pushViewController(vc,
                                                 animated: true)

    }
    
    
    @IBAction func morebtn_clk(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "BestSellProdsVC") as! BestSellProdsVC
        vc.productTradmarksData = moreProds
        vc.isMore = true
        navigationController?.pushViewController(vc,
                                                 animated: true)

    }
}
