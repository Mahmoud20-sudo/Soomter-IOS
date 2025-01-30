//
//  AdsSearchVC.swift
//  Soomter
//
//  Created by Mahmoud on 10/23/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class EventsSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var save_btn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var cities_tv: UITableView!
    @IBOutlet weak var catgs_tv: UITableView!
    @IBOutlet weak var ads_types_tv: UITableView!
    
    
    @IBOutlet weak var adslbl_top: NSLayoutConstraint!
    @IBOutlet weak var citestlbl_top: NSLayoutConstraint!
    @IBOutlet weak var citiestv_height: NSLayoutConstraint!
    @IBOutlet weak var catgstv_height: NSLayoutConstraint!
    @IBOutlet weak var adstypestv_height: NSLayoutConstraint!
    
    var citiesList : [CitiesData.Result] = []
    var catgsList : [CitiesData.Result] = []
    var adsTypesList : [CitiesData.Result] = []
    
    
    var mainVc : MainAdsVC?
    var allVc : AllAdsVC?
    
    var x : Int?
    var _title: String?
    var _type : Int?
    var categoryID : Int?
    
    var typeId = 0
    var cityId = 0
    var catgId = 0
    
    @IBOutlet weak var progressView: MSProgressView!
    
    @IBAction func save_clk(_ sender: UIButton) {
        print(typeId)
        if mainVc != nil{
            mainVc?.typeId = typeId
            mainVc?.cityId = cityId
            mainVc?.catId = catgId
        }
        else{
            allVc?.typeId = typeId
            allVc?.cityId = cityId
            allVc?.catId = catgId
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities_tv.isHidden = true
        
        save_btn.roundedWithBorder(radius: 12)
        
        progressView.isHidden = false
        progressView.start()
        progressView.start(automaticallyShow: true)
        progressView.setBar(color:UIColor.black, animated:true)
        
        let all = Bundle.main.localizedString(forKey: "all_ads", value: nil, table: "Default")
        let video = Bundle.main.localizedString(forKey: "vizeo_ads", value: nil, table: "Default")
        let photo = Bundle.main.localizedString(forKey: "imgs_ads", value: nil, table: "Default")
        let text = Bundle.main.localizedString(forKey: "txt_ads", value: nil, table: "Default")
        
        
        //
        //let imagesList = ["Home-Icon.png" , "Special-Ads-Icon.png","pic-ads-Icon.png", "Video-Ads-Icon.png", "Text-Ads-Icon.png"]
        let typeIdsList = [0, 3, 4, 1]
        let keyLsit = [all , text, photo, video]
        
        for var i in 0..<typeIdsList.count{
            
            var rsultObj = CitiesData.Result(name: keyLsit[i], id: typeIdsList[i], isChekced: false)
            adsTypesList.append(rsultObj)
        }
        
        getBussCatgs()
        
        cities_tv.dataSource = self
        cities_tv.delegate = self
        cities_tv.roundedWithBorder(radius: 5)
        
        catgs_tv.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        catgs_tv.dataSource = self
        catgs_tv.delegate = self
        catgs_tv.roundedWithBorder(radius: 5)
        
        cities_tv.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        
        ads_types_tv.dataSource = self
        ads_types_tv.delegate = self
        ads_types_tv.roundedWithBorder(radius: 5)
        
        ads_types_tv.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        
        // Do any additional setup after loading the view.
        
        
        if let recovedUserJsonData2 = UserDefaults.standard.object(forKey: "CITIES")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData2 as! Data)
            let cities = Mapper<CitiesData>().map(JSONObject: recovedUserJson)!
            //citiesList = cities.result!
            
            for var i in (0..<2){
                citiesList.append((cities.result?[i])!)
            }
            
            self.progressView.isHidden = true
            self.cities_tv.isHidden = false
            //setCatgsData(portalCatsList: portalCatsList!)
            
        }else{
            getCities( completionHandler: { (success) -> Void in
                // When download completes,control flow goes here.
                if success {
                    // download success
                    let recovedUserJson = NSKeyedUnarchiver     .unarchiveObject(with: UserDefaults.standard.object(forKey: "CITIES") as! Data)
                    let cities = Mapper<CitiesData>().map(JSONObject: recovedUserJson)!
                    self.citiesList = cities.result!
                    self.cities_tv.reloadData()
                    self.progressView.isHidden = true
                    self.cities_tv.isHidden = false
                    //self.setCatgsData(portalCatsList: self.portalCatsList!)
                } else {
                    // download fail
                    displayToastMessage("Error!")
                    self.progressView.isHidden = true
                    self.cities_tv.isHidden = false
                }
            })
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollview.contentSize = CGSize(width : scrollview.contentSize.width , height: 7000)
        
    }
    
    func getBussCatgs(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "BusinessCategoryId" : 0
        ]
        
        Alamofire.request(BUSSINES_CATGS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        let cities = Mapper<CitiesData>().map(JSONObject: json)!
                        //self.catgsList = cities.result!
                        
                        for var i in (0..<1){
                            self.catgsList.append((cities.result?[i])!)
                        }
                        
                        print(self.catgsList.count)
                        
                        self.catgs_tv.reloadData()
                        
                        self.progressView.isHidden = true
                        self.catgs_tv.isHidden = false
                        
                    }
                    break
                case .failure(let error):
                    self.progressView.isHidden = true
                    displayToastMessage("Error!")
                    break
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == cities_tv){
            return citiesList.count
        }
        else if (tableView == catgs_tv){
            return catgsList.count
        }
        else{
            return adsTypesList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == cities_tv{
            //            var frame = tableView.frame
            //            frame.size.height = tableView.contentSize.height
            //            tableView.frame = frame
            citiestv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
            
            //acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            //est_cons.constant = 20
            //acknowldge_lbl.layoutIfNeeded()
            //acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            //            inner_detailsview.addConstraint(NSLayoutConstraint(item: acknowldge_lbl, attribute: .top,
            //                                                               relatedBy: .equal, toItem: tableView,
            //                                                               attribute: .bottom, multiplier: 0, constant: -20))
            
        }
        else if tableView == catgs_tv{
            catgstv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
            
        }
        else if tableView == ads_types_tv{
            //            var frame = tableView.frame
            //            frame.size.height = tableView.contentSize.height
            //            tableView.frame = frame
            adstypestv_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
            //top_cons.constant = 60
            //top_cons_id
            //            let filteredConstraints = selected_inis_view.constraints.filter { $0.identifier == "top_cons_id" }
            //            if let yourConstraint = filteredConstraints.first {
            //                // DO YOUR LOGIC HERE
            //                yourConstraint.constant = 60
            //            }
            //selected_inis_view.layoutIfNeeded()
            //            acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            //            test_cons.constant = 20
            //            acknowldge_lbl.layoutIfNeeded()
            //acknowldge_lbl.translatesAutoresizingMaskIntoConstraints = false
            //            inner_detailsview.addConstraint(NSLayoutConstraint(item: acknowldge_lbl, attribute: .top,
            //                                                               relatedBy: .equal, toItem: tableView,
            //                                                               attribute: .bottom, multiplier: 0, constant: -20))
            
        }
        
    }
    
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        if (tableView == cities_tv){
    //            cityId = citiesList[indexPath.row].id!
    //        }
    //        else if (tableView == catgs_tv){
    //            catgId = catgsList[indexPath.row].id!
    //        }
    //        else{
    //            typeId = adsTypesList[indexPath.row].id!
    //        }
    //    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        x = indexPath.row
        
        if (tableView == cities_tv){
            let cell: CitiesCell = cities_tv.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
            
            cell.config(_obj: citiesList[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
                // When download completes,control flow goes here.
                if indexPath.row == 0{
                    for i in 0 ..< self.citiesList.count {
                        self.citiesList[i].isCheked = success
                    }
                    self.cityId = 0
                    self.cities_tv.reloadData()
                }
                else{
                    for i in 0 ..< self.citiesList.count {
                        self.citiesList[i].isCheked = false
                    }
                    self.cityId = self.citiesList[indexPath.row].id!
                    self.citiesList[indexPath.row].isCheked = true
                    self.cities_tv.reloadData()
                }
            })
            
            cell.top_container.roundedWithBorder(radius: 5)
            
            let corners:UIRectCorner = ([.topLeft , .topRight])
            let maskPAth1 = UIBezierPath(roundedRect: cell.bounds,
                                         byRoundingCorners: corners,
                                         cornerRadii:CGSize(width:5.0, height:5.0))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = cell.bounds
            maskLayer1.path = maskPAth1.cgPath
            cell.layer.mask = maskLayer1
            
            if indexPath.row == 0 {
                let corners2:UIRectCorner = ([.bottomLeft , .bottomRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.backgroundColor = UIColor.white
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
            }
            
            if indexPath.row == 1{
                let corners2:UIRectCorner = ([.topLeft , .topRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                cell.layer.mask = maskLayer2
                cell.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                
            }
            
            return cell
            
        }
        else if (tableView == catgs_tv){
            let cell: CitiesCell = catgs_tv.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
            
            cell.config(_obj: catgsList[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
                // When download completes,control flow goes here.
                if indexPath.row == 0{
                    for i in 0 ..< self.catgsList.count {
                        self.catgsList[i].isCheked = success
                    }
                    self.catgs_tv.reloadData()
                    self.catgId = 0
                }
                else{
                    for i in 0 ..< self.catgsList.count {
                        self.catgsList[i].isCheked = false
                    }
                    self.catgId = self.catgsList[indexPath.row].id!
                    self.catgsList[indexPath.row].isCheked = true
                    self.catgs_tv.reloadData()
                }
            })
            
            cell.top_container.roundedWithBorder(radius: 5)
            
            let corners:UIRectCorner = ([.topLeft , .topRight])
            let maskPAth1 = UIBezierPath(roundedRect: cell.bounds,
                                         byRoundingCorners: corners,
                                         cornerRadii:CGSize(width:5.0, height:5.0))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = cell.bounds
            maskLayer1.path = maskPAth1.cgPath
            cell.layer.mask = maskLayer1
            
            if indexPath.row == 0 {
                let corners2:UIRectCorner = ([.bottomLeft , .bottomRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.backgroundColor = UIColor.white
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
            }
            
            if indexPath.row == 1{
                let corners2:UIRectCorner = ([.topLeft , .topRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                cell.layer.mask = maskLayer2
                cell.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                
            }
            
            return cell
            
        }
        else {
            let cell: CitiesCell = ads_types_tv.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
            
            cell.config(_obj: adsTypesList[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
                // When download completes,control flow goes here.
                if indexPath.row == 0{
                    for i in 0 ..< self.adsTypesList.count {
                        self.adsTypesList[i].isCheked = success
                    }
                    self.ads_types_tv.reloadData()
                    self.typeId = 0
                }
                else{
                    for i in 0 ..< self.adsTypesList.count {
                        self.adsTypesList[i].isCheked = false
                    }
                    self.typeId = self.adsTypesList[indexPath.row].id!
                    self.adsTypesList[indexPath.row].isCheked = true
                    self.ads_types_tv.reloadData()
                }
            })
            
            cell.top_container.roundedWithBorder(radius: 5)
            
            let corners:UIRectCorner = ([.topLeft , .topRight])
            let maskPAth1 = UIBezierPath(roundedRect: cell.bounds,
                                         byRoundingCorners: corners,
                                         cornerRadii:CGSize(width:5.0, height:5.0))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = cell.bounds
            maskLayer1.path = maskPAth1.cgPath
            cell.layer.mask = maskLayer1
            
            if indexPath.row == 0 {
                let corners2:UIRectCorner = ([.bottomLeft , .bottomRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.backgroundColor = UIColor.white
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
            }
            
            if indexPath.row == 1{
                let corners2:UIRectCorner = ([.topLeft , .topRight])
                let maskPAth2 = UIBezierPath(roundedRect: cell.top_container.bounds,
                                             byRoundingCorners: corners2,
                                             cornerRadii:CGSize(width:5.0, height:5.0))
                let maskLayer2 = CAShapeLayer()
                maskLayer2.frame = cell.bounds
                maskLayer2.path = maskPAth2.cgPath
                cell.top_container.layer.mask = maskLayer2
                cell.top_container.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                cell.layer.mask = maskLayer2
                cell.dropShadow(color:
                    hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
                
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if x == 0{
            return 55.0 //Choose your custom row height
        } else {
            return 40
        }
    }
    
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        if(indexPath.row == 0)
    //        {
    //            return 55
    //        }
    //        else
    //        {
    //            return 40
    //        }
    //    }
}
