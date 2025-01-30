//
//  CompaniesVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/16/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import PagingTableView

class CompaniesVC: UIViewController , UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate{

    @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var showbycity_btn: UIButton!
    @IBOutlet weak var showbycatg_btn: UIButton!
    
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var comps_tv: PagingTableView!
    var catgID : Int?
    var _type : Int?
    var cityID : Int?
    var subCatg : Int?
    var numberOfItemsPerPage = 10
    
    var titleLbl : String?
    
    var user = User()
    
    var mostWtchedList : [MostWatchedComps.Result] = []
    var list : [CompaniesData.Items] = []
    
    // @IBOutlet weak var prentview_height: NSLayoutConstraint!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var selection_viwq: UIView!
    
    @IBOutlet weak var seaehc_view: UIView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var progressView: MSProgressView!
    @IBOutlet weak var serch_setting_img: UIImageView!
    @IBOutlet weak var serch_img: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableview_height: NSLayoutConstraint!
    @IBOutlet weak var settings_img: UIImageView!
    
    //For Pagination
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                comps_tv.isLoading = true
                if(isSearhing){
                    searchComps(at: pageNo){ contents in
                        self.list.append(contentsOf: contents)
                        print(self.list.count)
                        self.comps_tv.isLoading = false
                        self.comps_tv.reloadData()
                    }
                }
                else{
                    loadData(at: pageNo) { contents in
                        self.list.append(contentsOf: contents)
                        print(self.list.count)
                        self.comps_tv.isLoading = false
                        self.comps_tv.reloadData()
                    }
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentSize()
    }
    func updateContentSize(){
        var contentRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
//        prentview_height.constant = contentRect.size.height + 50
     //   contentRect.size.height = contentRect.size.height + 100
      //  scrollView.contentSize = contentRect.size
        
        
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width , height: contentRect.size.height + 500)
    }
    
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
        
        searchTF.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        searchTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        if mostWtchedList.count != 0 {
            title_lbl.text = Bundle.main.localizedString(forKey: "most_wanted", value: nil, table: "Default")
            selection_viwq.isHidden = true
            self.comps_tv.isHidden = false
            self.progressView.isHidden = true
        }
        else{
            progressView.start()
            progressView.start(automaticallyShow: true)
            progressView.setBar(color:UIColor.black, animated:true)
            title_lbl.text = titleLbl
        }

        showbycity_btn.roundedWithBorder(radius: 12)
        showbycatg_btn.roundedWithBorder(radius: 12)
        
        seaehc_view.roundedWithBorder(radius: 15)
        
        showbycity_btn.titleEdgeInsets = UIEdgeInsetsMake(-4,0,0,0)
        showbycatg_btn.titleEdgeInsets = UIEdgeInsetsMake(-4,0,0,0)
        // Do any additional setup after loading the view.
        
        if !searchTxt.isEmpty{
            isSearhing = true
            searchTF.text = searchTxt
            
            let msg = Bundle.main.localizedString(forKey: "serch_result", value: nil, table: "Default")
            title_lbl.text = msg
        }
        
        serch_setting_img.image = serch_setting_img.image!.withRenderingMode(.alwaysTemplate)
        serch_setting_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        serch_img.image = serch_img.image!.withRenderingMode(.alwaysTemplate)
        serch_img.tintColor = hexStringToUIColor(hex: "#8E8E93")
        
        self.comps_tv.isHidden = false
        //
        if Locale.preferredLanguages[0] != "en"{
            serch_img.transform = serch_img.transform.rotated(by: CGFloat(Double.pi / 2))
                       bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            user = Mapper<User>().map(JSONObject: recovedUserJson)!
            //print(user)
            
        }
        
        scrollView.delegate = self
        comps_tv.dataSource = self
        comps_tv.delegate = self
        comps_tv.isLoading = true
        if(isSearhing){
            searchComps(at: pageNo){ contents in
                self.list.append(contentsOf: contents)
                print(self.list.count)
                self.comps_tv.isLoading = false
                self.comps_tv.reloadData()
            }
        }
        else{
            loadData(at: pageNo) { contents in
                self.list.append(contentsOf: contents)
                print(self.list.count)
                self.comps_tv.isLoading = false
                self.comps_tv.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //list = []
        //comps_tv.reloadData()
    }
    
    var isSearhing = false
    func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            self.progressView.isHidden = false
            self.comps_tv.isHidden = true
            self.isSearhing = false
            pageNo = 1
            loadData(at: pageNo) { contents in
                self.list = []
                self.progressView.isHidden = true
                self.comps_tv.isHidden = false
                self.list = contents
                self.comps_tv.reloadData()
            }
        }
    }
    
    var searchTxt = ""
    func enterPressed(){
        //do something with typed text if needed
        searchTF.resignFirstResponder()
        self.list = []
        self.progressView.isHidden = false
        self.comps_tv.isHidden = true
        self.isSearhing = true
        if let text = searchTF.text{
            searchTxt = text
        }
        pageNo = 1
        searchComps(at: pageNo){ contents in
            self.list = contents
            
            self.progressView.isHidden = true
            self.comps_tv.isHidden = false
            self.comps_tv.isLoading = false
            self.comps_tv.reloadData()
        }
    }
    
    func searchComps(at page: Int, onComplete: @escaping ([CompaniesData.Items]) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let firstIndex = page * self.numberOfItemsPerPage
//            guard firstIndex < self.list.count else {
//
//
//            let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.list.count ?
//                (page + 1) * self.numberOfItemsPerPage : self.list.count
//            onComplete(Array(self.list[firstIndex ..< lastIndex]))
//
//        }
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": self.user.result?.id,
            "CategoryId": self.catgID ?? 0,
            "SubCategorId": self.subCatg ?? 0,
            "CityId": self.cityID ?? 0,
            "AdsTo": 1,
            "CurrentCompanyId": 0,
            "SearchText": self.searchTxt,
            "PageSize" : 10,
            "PageNumber" : page + 1
        ]
        
        
        print(self.searchTxt)
        
        Alamofire.request(COMPANIES_SEARCH_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {                                //   print(json)
                        //let eventData = Mapper<EventsData>().map(JSONObject: json)
                        print(json)
                        self.progressView.isHidden = true
                        let comps = Mapper<CompaniesData>().map(JSONObject: json)
                        if let list = comps?.result?.Items{
                            //self.eventsList = list
                            onComplete(list)
                            return
                        }
                    }
                    break
                case .failure(let error):
                    
                    self.progressView.isHidden = true
                    onComplete([])
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
    func loadData(at page: Int, onComplete: @escaping ([CompaniesData.Items]) -> Void) {
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "UserId": self.user.result?.id,
            "CategoryId": self.catgID ?? 0,
            "SubCategoryId": self.subCatg ?? 0,
            "CityId": self.cityID ?? 0,
            "AdsTo": 0,
            "CompanyId": 0,
            "PageSize" : 10,
            "PageNumber" : page
        ]
        
        print(parameters)
        
        Alamofire.request(COMPANIES_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {                                //   print(json)
                        //let eventData = Mapper<EventsData>().map(JSONObject: json)
                        print(json)
                        self.progressView.isHidden = true
                        let comps = Mapper<CompaniesData>().map(JSONObject: json)
                        if let list = comps?.result?.Items{
                            //self.eventsList = list
                            onComplete(list)
                            return
                        }
                    }
                    break
                case .failure(let error):
                    
                    self.progressView.isHidden = true
                    onComplete([])
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }
    
//    func getCompanies(){
//        let parameters: Parameters = [
//            "Lang": Locale.preferredLanguages[0],
//            "UserId": user.result?.id,
//            "CategoryId": catgID,
//            "SubCategoryId": 0,
//            "CityId": 0,
//            "AdsTo": 0,
//            "CompanyId": 0,
//            "PageSize" : 10,
//            "PageNumber" : 1
//        ]
//
//        Alamofire.request(COMPANIES_URL , method : .post, parameters :
//            parameters , encoding: JSONEncoding.default).responseJSON { response in
//             //   print("Request: \(String(describing: response.request))")   // original url request
//             ////   print("Response: \(String(describing: response.response))") // http url response
//               // print("Result: \(response.result)")                         // response serialization /result
//                switch response.result{
//                case .success:
//                    if let json = response.result.value {
//                       // print(json)
//                        let comps = Mapper<CompaniesData>().map(JSONObject: json)
//                        self.list = (comps?.result?.Items)!
//                        self.comps_tv.isHidden = false
//                        self.progressView.isHidden = true
//                        self.comps_tv.reloadData()
//                    }
//                    break
//                case .failure(let error):
//                    self.progressView.isHidden = true
//                    displayToastMessage(error.localizedDescription)
//                    break
//                }
//        }
//    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mostWtchedList.isEmpty
        {
            print(list.count)
            return list.count
        }else{
            return mostWtchedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mostWtchedList.isEmpty {
            let cell: MostWatchedCell = comps_tv.dequeueReusableCell(withIdentifier: "MostWatchedCell") as! MostWatchedCell
            
            cell.selectionStyle = .none
            //if list.count != 0 {
            cell.config2(_obj: (self.list[indexPath.row]), _user: user)
            //}
            
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
            return cell
        }
        else{
            let cell: MostWatchedCell = comps_tv.dequeueReusableCell(withIdentifier: "MostWatchedCell") as! MostWatchedCell
            if (Locale.preferredLanguages[0] == "en"){
                cell.top_view.semanticContentAttribute = .forceRightToLeft
                cell.stackView.semanticContentAttribute = .forceLeftToRight
                cell.inner_stackview.semanticContentAttribute = .forceRightToLeft
            }
            cell.selectionStyle = .none
            //if list.count != 0 {
            cell.config(_obj: (self.mostWtchedList[indexPath.row]), _user: user)
            //}
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//            //            var frame = tableView.frame
//            //            frame.size.height = tableView.contentSize.height
//            //            tableView.frame = frame
//            tableview_height.constant = tableView.contentSize.height
//            tableView.layoutIfNeeded()
//
//            updateContentSize()
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        var contentRect = CGRect.zero
        for view: UIView in self.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        prentview_height.constant = tableView.contentSize.height + 50
        //   contentRect.size.height = contentRect.size.height + 100
        //  scrollView.contentSize = contentRect.size
        print(tableView.contentSize.height)
        //print(contentRect.size.height)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width , height: tableView.contentSize.height + 100)
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyProfileVC") as! CompanyProfileVC
        if mostWtchedList.isEmpty {
            detailsVC.companyObj = self.list[indexPath.row]
        }else{
            detailsVC.mostWatchedObj = self.mostWtchedList[indexPath.row]
        }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showbycity_clk(_ sender: Any) {
        _type = 1
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC =   storyboard.instantiateViewController(withIdentifier: "CitiesVC") as! CitiesVC
        secondVC._type = _type
        secondVC.companyVC = self
        self.navigationController!.pushViewController(secondVC, animated: true)
        
       // performSegue(withIdentifier: "ChooseVC", sender: nil)
    }
    
    @IBAction func showbycatg_clk(_ sender: UIButton) {
        _type = 2
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC =   storyboard.instantiateViewController(withIdentifier: "CitiesVC") as! CitiesVC
        secondVC._type = _type
        secondVC.companyVC = self
        self.navigationController!.pushViewController(secondVC, animated: true)
        //performSegue(withIdentifier: "ChooseVC", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         let citiesVC = self.storyboard?.instantiateViewController(withIdentifier: "CitiesVC") as! CitiesVC
//         citiesVC._type = _type
//         self.navigationController?.pushViewController(citiesVC, animated: true)
//        
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
