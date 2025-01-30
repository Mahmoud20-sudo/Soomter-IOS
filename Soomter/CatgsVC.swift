//
//  CatgsVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/7/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher

class CatgsVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var mostwatch_view: UIView!
    @IBOutlet weak var catgs_vew: UIView!
    @IBOutlet weak var mostWatched_TV: UITableView!
    @IBOutlet weak var search_container: UIView!
    
    @IBOutlet weak var serch_img: UIImageView!
    @IBOutlet weak var options_img: UIImageView!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    @IBOutlet weak var first_container: UIView!
    @IBOutlet weak var first_img: UIImageView!
    @IBOutlet weak var first_lbl: UILabel!
    
    @IBOutlet weak var middle_container: UIView!
    @IBOutlet weak var middle_img: UIImageView!
    @IBOutlet weak var middle_lbl: UILabel!
    
    @IBOutlet weak var third_container: UIView!
    @IBOutlet weak var third_img: UIImageView!
    @IBOutlet weak var third_lbl: UILabel!
    
    var user = User()
    var portalCatsList : [PortalBussinsCatgsData.Result]?
    var list : [MostWatchedComps.Result] = []
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var mostwtched_showall_btn: UIButton!
    @IBOutlet weak var catgs_showall_btn: UIButton!
    @IBOutlet weak var progressView: MSProgressView!
    
    @IBOutlet weak var register_ins_btn: UIButton!
    // Data model: These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "MostWatchedCell"
    
    @IBAction func settingsbtn_clk(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBOutlet weak var bottom_stack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        search_container.roundedWithBorder(radius: 15)
        // Do any additional setup after loading the view.
        options_img.image = options_img.image!.withRenderingMode(.alwaysTemplate)
        options_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        serch_img.image = serch_img.image!.withRenderingMode(.alwaysTemplate)
        serch_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        
        if Locale.preferredLanguages[0] != "en"{
            serch_img.transform = serch_img.transform.rotated(by: CGFloat(Double.pi / 2))
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
            catgs_vew.semanticContentAttribute = .forceLeftToRight
            mostwatch_view.semanticContentAttribute = .forceLeftToRight
            mostWatched_TV.semanticContentAttribute = .forceLeftToRight
            bottom_stack.semanticContentAttribute = .forceLeftToRight
            
            
        }else{
            
            catgs_vew.semanticContentAttribute = .forceRightToLeft
            mostwatch_view.semanticContentAttribute = .forceRightToLeft
            mostWatched_TV.semanticContentAttribute = .forceRightToLeft
            bottom_stack.semanticContentAttribute = .forceRightToLeft
        }
        
        //mostWatched_TV.register(MostWatchedCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.mostWatched_TV.delegate = self
        self.mostWatched_TV.dataSource = self
        
        progressView.start()
        progressView.start(automaticallyShow: true)
        progressView.setBar(color:UIColor.black, animated:true)
        
        catgs_showall_btn.isEnabled = false
        mostwtched_showall_btn.isEnabled = false
        
        first_container.roundedWithBorder(radius: 5)
        middle_container.roundedWithBorder(radius: 5)
        third_container.roundedWithBorder(radius: 5)

        register_ins_btn.roundedWithBorder(radius: 15)
        
        first_container.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        middle_container.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        third_container.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            user = Mapper<User>().map(JSONObject: recovedUserJson)!
            //print(user)
            register_ins_btn.isHidden = false
        }
        
        if let recovedUserJsonData2 = UserDefaults.standard.object(forKey: "PortalBussinsCatgsData")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData2 as! Data)
            let portalBussObj = Mapper<PortalBussinsCatgsData>().map(JSONObject: recovedUserJson)!
            portalCatsList = portalBussObj.result
            setCatgsData(portalCatsList: portalCatsList!)
            
        }else{
            getPortalBussCatgs( completionHandler: { (success) -> Void in
                // When download completes,control flow goes here.
                if success {
                    // download success
                    let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "PortalBussinsCatgsData") as! Data)
                    let portalBussObj = Mapper<PortalBussinsCatgsData>().map(JSONObject: recovedUserJson)!
                    self.portalCatsList = portalBussObj.result
                    self.setCatgsData(portalCatsList: self.portalCatsList!)
                } else {
                    // download fail
                    displayToastMessage("Error!")
                }
            })

        }
        
        getMostWatchedCompanies()
        
        //view.addSubview(scrollview)
        self.scrollview.isScrollEnabled = true
        
    }

    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 900)
    }
    
    func setCatgsData(portalCatsList : [PortalBussinsCatgsData.Result]){
        catgs_showall_btn.isEnabled = true
        
        first_img.kf.setImage(with: URL(string: (portalCatsList[0].BusinessIcon64)!),
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        first_lbl.text = Locale.preferredLanguages[0] == "en" ? portalCatsList[0].EnglishName : portalCatsList[0].Name
        
        middle_img.kf.setImage(with: URL(string: (portalCatsList[1].BusinessIcon64)!),
                               placeholder: nil,
                               options: [.transition(.fade(1))],
                               progressBlock: nil,
                               completionHandler: nil)
        middle_lbl.text = Locale.preferredLanguages[0] == "en" ? portalCatsList[1].EnglishName : portalCatsList[1].Name
        
        
        third_img.kf.setImage(with: URL(string: (portalCatsList[2].BusinessIcon64)!),
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        third_lbl.text = Locale.preferredLanguages[0] == "en" ? portalCatsList[2].EnglishName : portalCatsList[2].Name
        
        first_container.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToCompScreen(_:))))
        
        middle_container.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToCompScreen1(_:))))
        
        third_container.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToCompScreen2(_:))))
    }

    func navigateToCompScreen(_ sender:UITapGestureRecognizer)  {
        let companiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
        
        companiesVC.catgID = portalCatsList?[0].id
        companiesVC.titleLbl =  Locale.preferredLanguages[0] == "en" ? portalCatsList?[0].EnglishName : portalCatsList?[0].Name
        
        navigationController?.pushViewController(companiesVC, animated: true)
    }
    
    func navigateToCompScreen1(_ sender:UITapGestureRecognizer)  {
        let companiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
        
        companiesVC.catgID = portalCatsList?[1].id
        companiesVC.titleLbl =  Locale.preferredLanguages[0] == "en" ? portalCatsList?[1].EnglishName : portalCatsList?[1].Name
        
        navigationController?.pushViewController(companiesVC, animated: true)
    }

    
    func navigateToCompScreen2(_ sender:UITapGestureRecognizer)  {
        let companiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
        
        companiesVC.catgID = portalCatsList?[2].id
        companiesVC.titleLbl =  Locale.preferredLanguages[0] == "en" ? portalCatsList?[2].EnglishName : portalCatsList?[2].Name
        
        navigationController?.pushViewController(companiesVC, animated: true)
    }

    
    @IBAction func register_clk(_ sender: UIButton) {
        let inistRegVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InistRegVC") as! InistRegVC
        navigationController?.pushViewController(inistRegVC, animated: true)
    }
    
    @IBAction func mostwtched_clk(_ sender: UIButton){
        let companiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
        
        companiesVC.mostWtchedList = self.list
        
        navigationController?.pushViewController(companiesVC, animated: true)
    }
    
    @IBAction func catgs_showall_clk(_ sender: UIButton) {
        let catgsAll = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllCatgsVC") as! AllCatgsVC
        
        catgsAll.portalCatsList = self.portalCatsList!
        
        navigationController?.pushViewController(catgsAll, animated: true)
    }

    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MostWatchedCell = mostWatched_TV.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MostWatchedCell
        
        if (Locale.preferredLanguages[0] == "en"){
            cell.top_view.semanticContentAttribute = .forceRightToLeft
            cell.stackView.semanticContentAttribute = .forceLeftToRight
            cell.inner_stackview.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cell.top_view.semanticContentAttribute = .forceLeftToRight
            cell.stackView.semanticContentAttribute = .forceRightToLeft
            cell.inner_stackview.semanticContentAttribute = .forceLeftToRight
        }
        
        cell.selectionStyle = .none
        //if list != nil {
            cell.config(_obj: (self.list[indexPath.row]), _user: user)
       // }
        
       
//        if(indexPath.row == animals.count - 1){
//            cell.divider.isHidden = true
//        }
        

        let corners:UIRectCorner = ([.topLeft , .topRight])
        let maskPAth1 = UIBezierPath(roundedRect: cell.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width:5.0, height:5.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = cell.bounds
        maskLayer1.path = maskPAth1.cgPath
        cell.layer.mask = maskLayer1
        
        let corners2:UIRectCorner = ([.bottomRight , .bottomLeft])
        let maskPAth2 = UIBezierPath(roundedRect: cell.stackView.bounds,
                                     byRoundingCorners: corners2,
                                     cornerRadii:CGSize(width:5.0, height:5.0))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.frame = cell.stackView.bounds
        maskLayer2.path = maskPAth2.cgPath
        cell.stackView.layer.mask = maskLayer2
        
        return cell
    }
    
//    //Lang :'ar',
//    UserId :  '11913df8-0e33-4ccc-acac-0adfcf2362b7' ,
//    CategoryId : 10,
//    SubCategoryId :,
//    CityId : ,
//    AdsTo : ,
//    CompanyId : ,

    func getMostWatchedCompanies(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": user.result?.id,
            "CategoryId": 0,
            "SubCategoryId": 0,
            "CityId": 0,
            "AdsTo": 0,
            "CompanyId": 0
        ]
        
        Alamofire.request(MOST_WATCHED_COMPANIES_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //print(json)
                        
                        self.mostwtched_showall_btn.isEnabled = true
                        let mostWathcedComps = Mapper<MostWatchedComps>().map(JSONObject: json)
                        self.list = (mostWathcedComps?.result)!
                        self.mostWatched_TV.isHidden = false
                        self.progressView.isHidden = true
                        self.mostWatched_TV.reloadData()
                    }
                    break
                case .failure(let error):
                    self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyProfileVC") as! CompanyProfileVC
        detailsVC.mostWatchedObj = list[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)

    }
}
