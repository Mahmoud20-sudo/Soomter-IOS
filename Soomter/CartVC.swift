//
//  CartVC.swift
//  Soomter
//
//  Created by Mahmoud on 10/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol DeletationDelegeat {
    func deleteItem( id : Int)
}

class CartVC: UIViewController, UITableViewDelegate , UITableViewDataSource,  DeletationDelegeat{

    @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var cartItems_tableview: UITableView!
    
    @IBOutlet weak var progressView: MSProgressView!
    
    @IBOutlet weak var conitnou_shopping_btn: UIButton!
    
    @IBOutlet weak var shipping_price_tv: UILabel!
    @IBOutlet weak var prods_num_tv: UILabel!
    @IBOutlet weak var price_count_tv: UILabel!
    @IBOutlet weak var total_tv: UILabel!
    
    
    @IBOutlet weak var browse_prods_lbl: UILabel!
    
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var empty_cart_view: UIView!
    @IBOutlet weak var confirm_view: UIView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var bottomView: UIView!
  //  var cartItems : [CartData.Items]
    
    var cartItems : [CartData.Items] = []
    var cartObject : CartData!
    
    
    var user: User!
    
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
        
//        if Locale.preferredLanguages[0] == "en"{
//            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
//        }
        
        progressView.start()
        progressView.start(automaticallyShow: true)
        progressView.setBar(color:UIColor.black, animated:true)
        
        
        conitnou_shopping_btn.roundedWithBorder(radius: 12)
        confirm_view.roundedWithBorder(radius: 8)
        
        cartItems_tableview.delegate = self
        cartItems_tableview.dataSource = self
        
        if Locale.preferredLanguages[0] == "en"
        {
            cartItems_tableview.semanticContentAttribute = .forceLeftToRight
            confirm_view.semanticContentAttribute = .forceRightToLeft
            bottomView.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cartItems_tableview.semanticContentAttribute = .forceRightToLeft
            confirm_view.semanticContentAttribute = .forceLeftToRight
            bottomView.semanticContentAttribute = .forceLeftToRight
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        loadCart()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prentview_height.constant = 900
        
        self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 1000)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func shoppingbtn_clk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "ProductsMainVC") as! ProductsMainVC

        navigationController?.pushViewController(vc,
                                                 animated: true)

  
      //  if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User"){
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier:
//                "ConfirmBuyingVC") as! ConfirmBuyingVC
//            vc.cartObj = cartObject
//            vc.user = user
//            navigationController?.pushViewController(vc,
//                                                     animated: true)
//        }
//        else{
//            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
//            displayToastMessage(msg)
//        }
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func loadCart(){
        
        self.progressView.isHidden = false
        self.cartItems_tableview.isHidden = true
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": user.result!.id!
            ]
        
        print(parameters)
        Alamofire.request(LOAD_CART_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        self.progressView.isHidden = true
                        let cartData = Mapper<CartData>().map(JSONObject: json)
                        self.cartItems = (cartData?.result?.Items)!
                        print(self.cartItems)
                        if self.cartItems.isEmpty{
                            self.empty_cart_view.isHidden = false
                            self.bottomView.isHidden = true
                            self.conitnou_shopping_btn.isHidden = true
                            
                            self.browse_prods_lbl.isUserInteractionEnabled = true
                            let gestureSwift2AndHigher2 = UITapGestureRecognizer(
                                target: self, action:  #selector (self.navToCartScreen(_:)))
                            self.browse_prods_lbl.addGestureRecognizer(gestureSwift2AndHigher2)
                            
                            return
                        }
                        self.cartObject = cartData
                        self.shipping_price_tv.text = "\(cartData?.result?.ShippingExpenses ?? 0) " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
                        self.prods_num_tv.text = "\(self.cartItems.count)"
                        self.cartItems_tableview.isHidden = false
                        var price = 0.0
                        for var i in 0..<self.cartItems.count{
                            price += self.cartItems[i].Price ?? 0
                        }
                        self.price_count_tv.text = "\(price) " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
                        self.total_tv.text = "\(price + Double(cartData?.result?.ShippingExpenses ?? 0)) " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
                        
                        self.cartItems_tableview.reloadData()
                        
                        self.confirm_view.isUserInteractionEnabled = true
                        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
                            target: self, action:  #selector (self.navToCartScreen(_:)))
                        self.confirm_view.addGestureRecognizer(gestureSwift2AndHigher2)
                        
                       
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    self.progressView.isHidden = true
                    self.cartItems_tableview.isHidden = false
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func navToCartScreen(_ sender:UITapGestureRecognizer)  {
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User"){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:
                "ConfirmBuyingVC") as! ConfirmBuyingVC
            vc.cartObj = cartObject
            vc.user = user
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_obj: self.cartItems[indexPath.row])
        cell.delgeatDeleting = self
        
        
        if Locale.preferredLanguages[0] == "en"
        {
            cell.semanticContentAttribute = .forceRightToLeft
            cell.contentView.semanticContentAttribute = .forceRightToLeft
            cell.container.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cell.semanticContentAttribute = .forceLeftToRight
            cell.contentView.semanticContentAttribute = .forceLeftToRight
            cell.container.semanticContentAttribute = .forceLeftToRight
        }
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func removeFromCArt( id : Int){
        let parameters: Parameters = [
            "CartItemId": id,
            "UserId": user.result!.id!
        ]
        
        print(parameters)
        Alamofire.request(REMOVE_FROM_CART , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    
                            let msg = Bundle.main.localizedString(forKey: "delete_success", value: nil, table: "Default")
                    displayToastMessage(msg)
                    self.loadCart()
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    self.progressView.isHidden = true
                    self.cartItems_tableview.isHidden = false
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func deleteItem( id : Int) {
        removeFromCArt(id: id)
    }
}
