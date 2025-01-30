//
//  ProductDetailsVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/5/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu
import ObjectMapper
import Cosmos
import JGProgressHUD

class ProductDetailsVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var menu_view: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var product_name_lbl: UILabel!
    
    @IBOutlet weak var product_model_lbl: UILabel!
    
    @IBOutlet weak var product_discount_lbl: UILabel!
    
    
    @IBOutlet weak var images_cv: UICollectionView!
    @IBOutlet weak var page_control: UIPageControl!
    @IBOutlet weak var old_price_lbl: UILabel!
    
    @IBOutlet weak var price_lbl: UILabel!
    
    @IBOutlet weak var tax_lbl: UILabel!
    @IBOutlet weak var shipping_lbl: UILabel!
    
    @IBOutlet weak var loc_lbl: UILabel!
    @IBOutlet weak var delivery_date_lbl: UILabel!
    
    
    @IBOutlet weak var quantity_tf: UITextField!
    @IBOutlet weak var plus_btn: UIButton!
    @IBOutlet weak var minus_btn: UIButton!
    
    
    @IBOutlet weak var xs_btn: UIButton!
    @IBOutlet weak var s_btn: UIButton!
    @IBOutlet weak var m_btn: UIButton!
    @IBOutlet weak var l_btn: UIButton!
    @IBOutlet weak var xl_btn: UIButton!
    @IBOutlet weak var xll_btn: UIButton!
    
    @IBOutlet weak var availability_lbl: UITextField!
    @IBOutlet weak var seller_name_label: UILabel!
    
    @IBOutlet weak var addtocart_view: UIView!
    
    @IBOutlet weak var general_btn: UIButton!
    @IBOutlet weak var props_btn: UIButton!
    @IBOutlet weak var ratings_btn: UIButton!
    
    @IBOutlet weak var general_view: UIView!
    @IBOutlet weak var props_view: UIView!
    @IBOutlet weak var ratings_view: UIView!
    
    
    @IBOutlet weak var similar_prods_cv: UICollectionView!
    @IBOutlet weak var description_textview: UITextView!
    @IBOutlet weak var advntgs_tv: UITableView!
    
    @IBOutlet weak var product_props_tv: UITableView!
    
    @IBOutlet weak var ratings_bar: CosmosView!
    
    @IBOutlet weak var total_raters_lbl: UILabel!
    
    @IBOutlet weak var user_ratingbar: CosmosView!
    
    @IBOutlet weak var ratings_tv: UITableView!
    
    var productObj : BestProductsData.Result!
    var imagesList : [ProductDetailsData.ImageList] = []
    var ratingLsit : [ProductDetailsData.ListRating] = []
    var productProps : [ProductDetailsData.ProductsProperties] = []
    var similarProducts : [ProductDetailsData.ListSelectedProducts] = []
    
    var animm = ["حححح","سيبسيب","سيبسيب"]
    
    @IBOutlet weak var cart_lbl: UILabel!
    
    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var fav_lbl: UILabel!
    @IBOutlet weak var settings_img: UIImageView!
    
    @IBOutlet weak var share_img: UIImageView!
    
    var hud : JGProgressHUD!
    
    func navigateToSettingsScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBOutlet weak var sizes_stack: UIStackView!
    @IBOutlet weak var fourth_view: UIView!
    @IBOutlet weak var third_view: UIView!
    @IBOutlet weak var second_view: UIView!
    @IBOutlet weak var first_view: UIView!
    @IBOutlet weak var stack_cont: UIView!
    @IBOutlet weak var prent_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        if Locale.preferredLanguages[0] == "en"{
            self.menu_view.semanticContentAttribute = .forceRightToLeft
            self.prent_view.semanticContentAttribute = .forceRightToLeft
            self.stack_cont.semanticContentAttribute = .forceLeftToRight
            self.first_view.semanticContentAttribute = .forceRightToLeft
            self.second_view.semanticContentAttribute = .forceRightToLeft
            self.third_view.semanticContentAttribute = .forceRightToLeft
            self.fourth_view.semanticContentAttribute = .forceRightToLeft
            self.ratings_view.semanticContentAttribute = .forceRightToLeft
             self.sizes_stack.semanticContentAttribute = .forceRightToLeft
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }else{
            self.addtocart_view.semanticContentAttribute = .forceLeftToRight
                self.menu_view.semanticContentAttribute = .forceLeftToRight
                self.prent_view.semanticContentAttribute = .forceLeftToRight
                self.stack_cont.semanticContentAttribute = .forceRightToLeft
                self.first_view.semanticContentAttribute = .forceLeftToRight
                self.second_view.semanticContentAttribute = .forceLeftToRight
                self.third_view.semanticContentAttribute = .forceLeftToRight
                self.fourth_view.semanticContentAttribute = .forceLeftToRight
                self.ratings_view.semanticContentAttribute = .forceLeftToRight
                self.sizes_stack.semanticContentAttribute = .forceLeftToRight
                
                bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
        }
        
        settings_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher = UITapGestureRecognizer(
            
            target: self, action:  #selector (self.navigateToSettingsScreen(_:)))
        
        settings_img.addGestureRecognizer(gestureSwift2AndHigher)
        //self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1450)

        menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] == "en"{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        //menu_btn.isEnabled = false
        
        general_btn.roundedWithBorder(radius: 5)
        props_btn.roundedWithBorder(radius: 5)
        ratings_btn.roundedWithBorder(radius: 5)
        
        clearSelection()
        getProductDetails()
        
        ratings_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        ratings_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#51504f")
        ratings_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        ratings_view.isHidden = false
        
        price_lbl.roundedWithBorder(radius: 5)
        quantity_tf.roundedWithBorder(radius: 5)
        xs_btn.roundedWithBorder(radius: 5)
        s_btn.roundedWithBorder(radius: 5)
        
        s_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        s_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        m_btn.roundedWithBorder(radius: 5)
        l_btn.roundedWithBorder(radius: 5)
        xl_btn.roundedWithBorder(radius: 5)
        xll_btn.roundedWithBorder(radius: 5)
        addtocart_view.roundedWithBorder(radius: 5)
        addtocart_view.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        availability_lbl.roundedWithBorder(radius: 5)
//        
//        self.scrollview.isUserInteractionEnabled = true;
//        self.scrollview.isExclusiveTouch = true;
//        self.scrollview.canCancelContentTouches = true;
//        self.scrollview.delaysContentTouches = false;

        self.similar_prods_cv.delegate = self
        self.similar_prods_cv.dataSource = self
        self.advntgs_tv.delegate = self
        self.advntgs_tv.dataSource = self
        self.product_props_tv.delegate = self
        self.product_props_tv.dataSource = self
        self.ratings_tv.delegate = self
        self.ratings_tv.dataSource = self
        
        self.images_cv.delegate = self
        self.images_cv.dataSource = self
        
        cart_lbl.isUserInteractionEnabled = true
        fav_lbl.isUserInteractionEnabled = true
        
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(
            target: self, action:  #selector (self.addToCrtClk(_:)))
        fav_lbl.addGestureRecognizer(gestureSwift2AndHigher3)
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.navToCartScreen(_:)))
        
        cart_lbl.addGestureRecognizer(gestureSwift2AndHigher2)
        
        share_img.isUserInteractionEnabled = true
        let gestureSwift2AndHigher5 = UITapGestureRecognizer(
            target: self, action:  #selector (self.sshare(_:)))
        share_img.addGestureRecognizer(gestureSwift2AndHigher5)
        
    }
    
    override func viewDidLayoutSubviews(){
        minus_btn.layer.cornerRadius = minus_btn.bounds.size.width / 2.0
        minus_btn.clipsToBounds = true
        plus_btn.layer.cornerRadius = minus_btn.bounds.size.width / 2.0
        plus_btn.clipsToBounds = true
    }
    
    func sshare(_ sender:UITapGestureRecognizer)  {
        let items = [URL(string: "https://www.soomter.com")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sharebtn_clk(_ sender: UIButton) {
        
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
    
    func addToCrtClk(_ sender:UITapGestureRecognizer)  {
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let curentUser = user{
                adToCart(user : curentUser)
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
    
    func adToCart(user: User){
        
        let parameters: Parameters = [
            "ProductFieldValueId": obj.ProductFieldValueId,
            "ProductId": obj.Id,
            "UserId": user.result!.id!,
            "Quantitiy": quantity_tf.text ?? 0
        ]
        
        print(quantity_tf.text ?? 0)
        
        Alamofire.request(ADD_TO_CART_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //      print("JSON: \(json)") // serialized json response
                        let msg = Bundle.main.localizedString(forKey: "added_success", value: nil, table: "Default")
                        
                        displayToastMessage(msg)
                    }
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    
    @IBAction func leftarrow_clk(_ sender: UIButton) {
        let visibleItems: NSArray = self.images_cv.indexPathsForVisibleItems as NSArray
        
        
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        
        for itr in visibleItems {
            
            if minItem.row > (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        
        let nextItem = NSIndexPath(row: minItem.row + 1, section: 0)
        
        print(imagesList.count)
        print(nextItem.row)
        if nextItem.row == imagesList.count{
            return
        }
        self.images_cv.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        
    }
    @IBAction func similar_prods_leftarrow_clk(_ sender: UIButton) {
    }
    @IBAction func rightarrow_clk(_ sender: UIButton) {
        let visibleItems: NSArray = self.images_cv.indexPathsForVisibleItems as NSArray
        
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {
            
            if minItem.row < (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        
        let nextItem = NSIndexPath(row: minItem.row - 1, section: 0)
        print(nextItem.row)
        if nextItem.row == -1{
            return
        }
        self.images_cv.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
    }
    @IBAction func write_rate_btn_clk(_ sender: UIButton) {
    }
    @IBAction func similar_prods_rightarrow_clk(_ sender: UIButton) {
    }
    @IBAction func general_btn_clk(_ sender: UIButton) {
        clearSelection()
        general_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        general_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#51504f")
        general_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ratings_view.isHidden = true
        general_view.isHidden = false
        props_view.isHidden = true
    }
    @IBAction func props_btn_clk(_ sender: UIButton) {
        clearSelection()
        props_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        props_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#51504f")
        props_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ratings_view.isHidden = true
        general_view.isHidden = true
        props_view.isHidden = false
    }
    @IBAction func ratings_btn_clk(_ sender: UIButton) {
        clearSelection()
        ratings_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        ratings_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#51504f")
        ratings_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ratings_view.isHidden = false
        general_view.isHidden = true
        props_view.isHidden = true
    }
    @IBAction func xllbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        xll_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        xll_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func xlbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        xl_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        xl_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func lbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        l_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        l_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func mbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        m_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        m_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func sbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        s_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        s_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func xsbtn_clk(_ sender: UIButton) {
        clearSizesSelection()
        xs_btn.backgroundColor = hexStringToUIColor(hex: "#FFDB92")
        xs_btn.dropShadow(color: hexStringToUIColor(hex: "#FFDB92"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    @IBAction func minusbtn_clk(_ sender: UIButton) {
        if let txt = quantity_tf.text{
         
            
            var qunt = (Int(txt) ?? 1) - 1
            if qunt <= 0{
                return
            }
            quantity_tf.text = "\(qunt)"
        }
    }
    @IBAction func plusbtn_clk(_ sender: UIButton) {
        if let txt = quantity_tf.text{
            
            
            var qunt = (Int(txt) ?? 1) + 1
            quantity_tf.text = "\(qunt)"
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1450)
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menubtn_clk(_ sender: UIButton) {
        if Locale.preferredLanguages[0] == "en" {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }else{
            present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == advntgs_tv{
            let cell: ProdsPropsCell = tableView.dequeueReusableCell(withIdentifier: "ProdsPropsCell") as! ProdsPropsCell
            //if list != nil {
            cell.config(_obj: self.productProps[indexPath.row])
            cell.view?.roundedWithBorder(radius: 5)
            
            var frame = tableView.frame
            frame.size.height = tableView.contentSize.height
            tableView.frame = frame

            return cell
        }
        if tableView == product_props_tv{
            let cell: ProdsPropsCell = tableView.dequeueReusableCell(withIdentifier: "ProdsPropsCell") as! ProdsPropsCell
            //if list != nil {
            cell.config2(_obj: self.productProps[indexPath.row])
            cell.view?.roundedWithBorder(radius: 5)
            
            var frame = tableView.frame
            frame.size.height = tableView.contentSize.height
            tableView.frame = frame
            
             frame = self.props_view.frame
            frame.size.height = tableView.contentSize.height + 25
            props_view.frame = frame
            
            //self.props_view.frame = frame
            
            return cell
        }
        if tableView == ratings_tv{
            let cell: RatingsCell = tableView.dequeueReusableCell(withIdentifier: "RatingsCell") as! RatingsCell
            //if list != nil {
            
            //cell.config(_obj: self.ratingLsit[indexPath.row])
            cell.config2(_obj: self.animm[indexPath.row])
            cell.container_view.roundedWithBorder(radius: 5)
            
            var frame = tableView.frame
            frame.size.height = tableView.contentSize.height
            tableView.frame = frame
            
            frame = self.props_view.frame
            frame.size.height = tableView.contentSize.height + 25
            props_view.frame = frame
            
            //self.props_view.frame = frame
            
            return cell

        }
        
        return UITableViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.page_control.currentPage = indexPath.row
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similar_prods_cv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellProdsCell", for: indexPath) as! BestSellProdsCell
            //cell.albl?.text = self.animals[indexPath.row]
            cell.config2(_obj: self.similarProducts[indexPath.row])
            
            return cell

        }
        if collectionView == images_cv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdsImgsCell", for: indexPath) as! ProdsImgsCell
            //cell.albl?.text = self.animals[indexPath.row]
            cell.config(_obj: self.imagesList[indexPath.row])
            
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similar_prods_cv{
            return similarProducts.count
        }
        if collectionView == images_cv{
            return imagesList.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == advntgs_tv{
            return productProps.count
        }
        if tableView == product_props_tv{
            return productProps.count
        }
        if tableView == ratings_tv{
            return animm.count
        }
        
        return 0
    }

    func clearSelection(){
        general_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        props_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        ratings_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        
        general_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#7C8487")
        props_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#7C8487")
        ratings_btn.titleLabel?.tintColor = hexStringToUIColor(hex: "#7C8487")
        
        general_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        props_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        ratings_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    
    func clearSizesSelection(){
        xs_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        s_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        m_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        l_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        xl_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        xll_btn.backgroundColor = hexStringToUIColor(hex: "#F9F9F9")
        
        xs_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        s_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        m_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        l_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        xl_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        xll_btn.dropShadow(color: UIColor.clear, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
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
    
    var obj : ProductDetailsData.Result!
    
    func getProductDetails(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "ProductId": productObj.Id,
            "FieldId": productObj.ProductFieldValueId,
            "CurrentUserId": "",
        ]
        Alamofire.request(PRODUCT_DETAILS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                self.hud.dismiss(afterDelay: 0.0)
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //print(json)
                        let data = Mapper<ProductDetailsData>().map(JSONObject: json)
                        self.product_name_lbl.text = data?.result?.Title
                        self.product_model_lbl.text = data?.result?.TradeMark
                    
                        self.obj = data?.result
                        
                        let gestureSwift2AndHigher = UITapGestureRecognizer(
                            target: self, action:  #selector (self.addToCrtClk(_:)))
                        self.addtocart_view.addGestureRecognizer(gestureSwift2AndHigher)
                        
                        if let discount = data?.result?.Discount
                        {
                            if discount == 0 {
                                self.product_discount_lbl.isHidden = true
                                self.old_price_lbl.isHidden = true
                            }
                            self.product_discount_lbl.text = Bundle.main.localizedString(forKey: "discount", value: nil, table: "Default")
                                                            + " " + "%\(discount)"
                        }
                        if let price = data?.result?.Price
                        {
                            let text = " " + "\(price)" + " " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default") + " "
                            
                            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                            attributeString.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: NSMakeRange(0, attributeString.length))
                            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                            self.old_price_lbl.attributedText = attributeString

                        }
                        if let price = data?.result?.PriceAfterDis
                        {
                            self.price_lbl.text = "\(price)" + " " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
                        }
                        self.tax_lbl.text = data?.result?.IncludesValueAddedstring
                        self.loc_lbl.text = data?.result?.ShippingCityId
                        self.delivery_date_lbl.text = data?.result?.ShippingDate
                        self.shipping_lbl.text = (data?.result?.FreeShipping)! ? Bundle.main.localizedString(forKey: "free_shipp", value: nil, table: "Default") : ""
                        self.seller_name_label.text = data?.result?.CompanyName
                        
                        self.imagesList = (data?.result?.ImageList)!
                        self.ratingLsit = (data?.result?.listRating)!
                        self.productProps = (data?.result?.ProductsProperties)!
                        self.similarProducts = (data?.result?.ListSelectedProducts)!
                    
                        self.description_textview.text = data?.result?.Details
                        //self.availability_lbl.text = data?.result?.
                        self.advntgs_tv.reloadData()
                        self.similar_prods_cv.reloadData()
                        self.product_props_tv.reloadData()
                        
                        self.ratings_bar.text = "\(3)"
                        self.ratings_bar.rating = 3.0
                        
                        self.total_raters_lbl.text = "\(2451)"
                        self.ratings_tv.reloadData()
                        
                        self.images_cv.reloadData()
                        self.page_control.numberOfPages = self.imagesList.count
                        
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
