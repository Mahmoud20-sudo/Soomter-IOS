//
//  ViewController.swift
//  Soomter
//
//  Created by Mahmoud on 8/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statsTv: UITableView!
    var countData = [AdsStatisticsClass]()
    var eventCountsData : [EventCountsData.Result] = []
    var mainAdsVC : MainAdsVC?
    var allAdsVC : AllAdsVC?
    var eventVC : EventsVC?
    
//    init(countData : [[String: Any]]){
//        super.init(nibName: nil, bundle: nil)
//
//        self.countData = countData
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = hexStringToUIColor(hex: "#191919" , alpha : 0.0)
      
        //print(countData)
        //print(countData.count)
        
        statsTv.delegate = self
        statsTv.dataSource = self
        
        if Locale.preferredLanguages[0] == "en"{
            statsTv.semanticContentAttribute = .forceRightToLeft
            
        }
        else{
            
            statsTv.semanticContentAttribute = .forceLeftToRight
        }
        self.statsTv.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if eventCountsData.isEmpty {
            let cell: AdsStatCell = statsTv.dequeueReusableCell(withIdentifier: "AdsStatCell") as! AdsStatCell
            
        //if list.count != 0 {
            cell.selectionStyle = .none
            cell.config(_obj: countData[indexPath.row])
            return cell
        }else{
            let cell: AdsStatCell = statsTv.dequeueReusableCell(withIdentifier: "AdsStatCell") as! AdsStatCell
            cell.selectionStyle = .none
            //if list.count != 0 {
            cell.config(_obj: eventcountsData[indexPath.row])
            return cell
        }
        
        
        //}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if eventCountsData.isEmpty {
            if allAdsVC != nil{
                allAdsVC?.changeTap(postion: indexPath.row)
            }
            else{
                mainAdsVC?.changeTap(postion: indexPath.row)
            }
        }
        else{
            eventVC?.changeTypeEvent(eventTypeId: eventCountsData[indexPath.row].Id!)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventCountsData.isEmpty {
            return countData.count
        }
        else{
            return eventcountsData.count
        }
    }
}
