//
//  EventsFavVC.swift
//
//
//  Created by Mahmoud on 10/24/18.
//
//

import UIKit
import Alamofire
import ObjectMapper
import PagingTableView

class EventsFavVC: UIViewController, PagingTableViewDelegate, UITableViewDataSource , UITableViewDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: MSProgressView!
    @IBOutlet weak var events_ptv: PagingTableView!
    
    @IBOutlet weak var bck_btn: UIButton!
    
    var eventsList : [EventsData.Items] = []
    
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
        
        //menu_view.dropShadow(color: hexStringToUIColor(hex: "#000000"), opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
        if Locale.preferredLanguages[0] == "en"{
            //bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
            events_ptv.semanticContentAttribute = .forceRightToLeft
        }
        else{
            
            events_ptv.semanticContentAttribute = .forceLeftToRight
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
        events_ptv.dataSource = self
        events_ptv.pagingDelegate = self
        events_ptv.delegate = self
        
        progressView.isHidden = true
        
    }
    
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    let numberOfItemsPerPage = 10
    
    func loadData(at page: Int, onComplete: @escaping ([EventsData.Items]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let firstIndex = page * self.numberOfItemsPerPage
            guard firstIndex < self.eventsList.count else {
                let parameters: Parameters = [
                    "Lang": Locale.preferredLanguages[0],
                    "FromDate": "",
                    "ToDate": "",
                    "CategoryId": 0,
                    "ComapnyId": 0,
                    "CityId": 0,
                    "EventTypeId": 0,
                    "SearchText":  "",
                    "PageSize": 10,
                    "IsFavourit" : 1,
                    "PageNumber": page + 1,
                    ]
                
                print(parameters)
                
                Alamofire.request(EVENTS_URL , method : .post, parameters :
                    parameters , encoding: JSONEncoding.default).responseJSON { response in
                        // print("Request: \(String(describing: response.request))")   // original url request
                        // print("Response: \(String(describing: response.response))") // http url response
                        // print("Result: \(response.result)")                         // response serialization result
                        switch response.result{
                        case .success:
                            if let json = response.result.value {                                //   print(json)
                                let eventData = Mapper<EventsData>().map(JSONObject: json)
                                if let list = eventData?.result?.Items{
                                    //self.eventsList = list
                                    onComplete(list)
                                    return
                                }
                            }
                            break
                        case .failure(let error):
                            onComplete([])
                            displayToastMessage(error.localizedDescription)
                            break
                        }
                }
                return
            }
            
            let lastIndex = (page + 1) * self.numberOfItemsPerPage < self.eventsList.count ?
                (page + 1) * self.numberOfItemsPerPage : self.eventsList.count
            onComplete(Array(self.eventsList[firstIndex ..< lastIndex]))
            
        }
    }
    
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
        //cell.albl?.text = self.animals[indexPath.row]
        cell.config(_obj: self.eventsList[indexPath.row])
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        events_ptv.isLoading = true
        loadData(at: page) { contents in
            self.eventsList.append(contentsOf: contents)
            self.events_ptv.isLoading = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as! EventsDetailsVC
        
        eventDetailsVC.eventObj = eventsList[indexPath.row]
        navigationController?.pushViewController(eventDetailsVC, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllAdsVC"{
            //            let vc = segue.destination as! AllAdsVC
            //            vc.adsData = self.adsData
            //            vc.selctedBarIndex = selctedBarIndex
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    
}
