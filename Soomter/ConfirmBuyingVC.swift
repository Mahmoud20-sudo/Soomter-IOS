//
//  ConfirmBuyingVC.swift
//  Soomter
//
//  Created by Mahmoud on 10/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ConfirmBuyingVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var detscont_height: NSLayoutConstraint!
    
    @IBOutlet weak var carttable_height: NSLayoutConstraint!
    @IBOutlet weak var addresstable_height: NSLayoutConstraint!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    @IBOutlet weak var prent_view: UIView!
    @IBOutlet weak var addresses_tv: UITableView!
    @IBOutlet weak var addloc_lbl: UILabel!
    
    @IBOutlet weak var confirm_view: UIView!
    @IBOutlet weak var total_lbl: UILabel!
    @IBOutlet weak var shipping_price_lbl: UILabel!
    @IBOutlet weak var delivery_price_lbl: UILabel!
    @IBOutlet weak var price_count_lbl: UILabel!
    @IBOutlet weak var cart_details_tv: UITableView!
    @IBOutlet weak var loca_time_lbl: UILabel!
    @IBOutlet weak var details_progressView: MSProgressView!
   
    
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var dets_cont: UIView!
    
    var addressList : [ProductAddreseData.Result] = []
    var user : User!
    var cartObj : CartData!
    var cartItems : [CartData.Items] = []
    
    @IBOutlet weak var scrollview: UIScrollView!
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
        
        details_progressView.start()
        details_progressView.start(automaticallyShow: true)
        details_progressView.setBar(color:UIColor.black, animated:true)
        
        addresses_tv.roundedWithBorder(radius: 12)
        dets_cont.roundedWithBorder(radius: 12)
        confirm_view.roundedWithBorder(radius: 8)
        
        cart_details_tv.delegate = self
        cart_details_tv.dataSource = self
        
        addresses_tv.delegate = self
        addresses_tv.dataSource = self
        
        if Locale.preferredLanguages[0] == "en"{
            prent_view.semanticContentAttribute = .forceRightToLeft
            dets_cont.semanticContentAttribute = .forceRightToLeft
            confirm_view.semanticContentAttribute = .forceRightToLeft
        }else{
              bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            bottom_view.semanticContentAttribute = .forceLeftToRight
            prent_view.semanticContentAttribute = .forceLeftToRight
            dets_cont.semanticContentAttribute = .forceLeftToRight
            confirm_view.semanticContentAttribute = .forceLeftToRight
        }
        
        cartItems = cartObj.result!.Items!
        getAddresses()
        // Do any additional setup after loading the view.
        //deliver-on
        var price = 0.0;
        for var i in 0..<self.cartItems.count{
            price += self.cartItems[i].Price ?? 0
        }
        self.price_count_lbl.text = "\(price) " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        var total = "\(price + Double(cartObj.result?.ShippingExpenses ?? 0)) "
        total += "\(cartObj.result?.CashOnDeliveryFees ?? 0)" + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        self.total_lbl.text = total
//
        shipping_price_lbl.text = "\(cartObj.result?.ShippingExpenses ?? 0) " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        delivery_price_lbl.text = "\(cartObj.result?.CashOnDeliveryFees ?? 0)  " + Bundle.main.localizedString(forKey: "r.s", value: nil, table: "Default")
        var loctime = Bundle.main.localizedString(forKey: "shipped-to", value: nil, table: "Default")
        loctime += (cartObj.result?.ShippingCity ?? "") + " - "
        loctime += Bundle.main.localizedString(forKey: "deliver-on", value: nil, table: "Default") + (cartObj.result?.DeliverDate ?? "")
        
        
        loca_time_lbl.text = loctime
//
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(
            target: self, action:  #selector (self.processCart(_:)))
        confirm_view.addGestureRecognizer(gestureSwift2AndHigher2)
        

        prentview_height.constant = 1080
        self.view.layoutIfNeeded()
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 1100)
    }
    
    func processCart(_ sender:UITapGestureRecognizer)  {
        processCArt()
    }
    
    
    @IBAction func addloc_btn(_ sender: UIButton) {
       processCArt()
    }
    
  
    func getAddresses(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": user.result!.id!
        ]
        
        print(parameters)
        Alamofire.request(GET_ADDRESS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                self.details_progressView.isHidden = true
                switch response.result{
                case .success:
                    if let json = response.result.value{
                        let data = Mapper<ProductAddreseData>().map(JSONObject: json)
                        self.addressList = (data?.result)!
                        self.addresses_tv.reloadData()
                        
                    }
                    
                    break
                case .failure(let error):
                    self.addresses_tv.isHidden = false
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
  
    func processCArt(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": user.result!.id!
        ]
        
        print(parameters)
        Alamofire.request(PROCESS_CART_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value{
                        //f
                        print(json)
                        displayToastMessage(Bundle.main.localizedString(forKey: "process-sucess", value: nil, table: "Default"))
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    break
                case .failure(let error):
                    self.addresses_tv.isHidden = false
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addresses_tv{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell", for: indexPath) as! AddressesCell
            //cell.albl?.text = self.animals[indexPath.row]
            if Locale.preferredLanguages[0] == "en"
            {
                cell.contentView.semanticContentAttribute = .forceRightToLeft
            }
            cell.config(_obj: addressList[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
            // When download comple
            for i in 0 ..< self.addressList.count {
                    self.addressList[i].isCheked = false
                    self.addressList[i].Isdefault = false
                }
                self.addressList[indexPath.row].Isdefault = true
                self.addressList[indexPath.row].isCheked = true
                self.addresses_tv.reloadData()
            //self.navigationController?.popViewController(animated: true)
            
            })
            
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemsDetCell", for: indexPath) as! CartItemsDetCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_obj: self.cartItems[indexPath.row])
        
        if Locale.preferredLanguages[0] == "en"
        {
            cell.container.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cell.container.semanticContentAttribute = .forceLeftToRight
        }
        //cell.delgeatDeleting = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        if (tableView == cart_details_tv){
            detscont_height.constant = tableView.frame.height + 50
            dets_cont.layoutIfNeeded()
        }
        else{
            addresstable_height.constant = tableView.contentSize.height
        }
        
        tableView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.prent_view.layoutIfNeeded()
        var contentRect = CGRect.zero
        for view: UIView in self.prent_view.subviews {
            contentRect = contentRect.union(view.frame)
        }
        prentview_height.constant = contentRect.height + 50
        
        
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: prentview_height.constant + 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == addresses_tv){
            return addressList.count
        }
        return cartItems.count
    }
}
