//
//  CompaniesVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/15/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class CitiesVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var cities_tv: UITableView!
    
    @IBOutlet weak var bck_btn: UIButton!
    var citiesList : [CitiesData.Result] = []
    var x : Int?
    var _title: String?
    var _type : Int?
    var categoryID : Int?
    var companyVC : CompaniesVC?
    
    @IBOutlet weak var progressView: MSProgressView!
    
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

        cities_tv.isHidden = true
        
        if Locale.preferredLanguages[0] != "en"{
             bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
        progressView.start()
        progressView.start(automaticallyShow: true)
        progressView.setBar(color:UIColor.black, animated:true)
        
        cities_tv.dataSource = self
        cities_tv.delegate = self
        cities_tv.roundedWithBorder(radius: 5)
        
        cities_tv.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        // Do any additional setup after loading the view.
        
        if _type == 1 {
        
            if let recovedUserJsonData2 = UserDefaults.standard.object(forKey: "CITIES")
            {
                let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData2 as! Data)
                let cities = Mapper<CitiesData>().map(JSONObject: recovedUserJson)!
                citiesList = cities.result!
                
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
        }else{
                getBussCatgs()
        }
    }

    func getBussCatgs(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "BusinessCategoryId" : 10
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
                        self.citiesList = cities.result!
                        self.cities_tv.reloadData()
                        
                        self.progressView.isHidden = true
                        self.cities_tv.isHidden = false

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
        return citiesList.count
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        x = indexPath.row
        
        let cell: CitiesCell = cities_tv.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
        
        cell.config(_obj: citiesList[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
            // When download completes,control flow goes here.
            if indexPath.row == 0{
                for i in 0 ..< self.citiesList.count {
                    self.citiesList[i].isCheked = success
                }
                self.cities_tv.reloadData()
                
                if self._type == 1 {
                    self.companyVC?.cityID = self.citiesList[indexPath.row].id
                }else{
                    self.companyVC?.subCatg = self.citiesList[indexPath.row].id
                }
                self.navigationController?.popViewController(animated: true)
            }
            else{
                for i in 0 ..< self.citiesList.count {
                    self.citiesList[i].isCheked = false
                }
                self.citiesList[indexPath.row].isCheked = true
                self.cities_tv.reloadData()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if self._type == 1 {
                    self.companyVC?.cityID = self.citiesList[indexPath.row].id
                }else{
                    self.companyVC?.subCatg = self.citiesList[indexPath.row].id
                }
                self.navigationController?.popViewController(animated: true)
                
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
        if Locale.preferredLanguages[0] != "en"{
            cell.top_container.semanticContentAttribute = .forceLeftToRight
            
        }
        return cell
    }
    
    @IBOutlet weak var tableview_height: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
            tableview_height.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
        
            scroll_view.contentSize = CGSize(width: scroll_view.contentSize.width , height: tableView.contentSize.height + 100)
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
