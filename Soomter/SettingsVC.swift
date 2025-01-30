//
//  SettingsVC.swift
//  Soomter
//
//  Created by Mahmoud on 11/4/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import ObjectMapper
import L10n_swift

class SettingsVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var logout_btn: UIButton!
    @IBOutlet weak var languages_tableview: UITableView!
    @IBOutlet weak var prent_View: UIView!
    @IBOutlet weak var bck_btn: UIButton!
    
    var languages : [CitiesData.Result] = []
    var langaugeId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let typeIdsList = [1 , 2]
        let keyLsit = ["العربية" , "English"]
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            if let currentUser = user{
                username_lbl.text = currentUser.result!.name ?? ""
                logout_btn.isHidden = false
            }
        }
        
        let langStr = Locale.current.languageCode
        let checkedList = [langStr == "ar" ? true : false , langStr == "en" ? true : false]
        
        for var i in 0..<typeIdsList.count{
            
            let rsultObj = CitiesData.Result(name: keyLsit[i], id: typeIdsList[i], isChekced: checkedList[i])
            languages.append(rsultObj)
        }
        
        
        if Locale.preferredLanguages[0] != "en" {
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            self.prent_View.semanticContentAttribute = .forceLeftToRight
            
        }
        else{
            
            self.prent_View.semanticContentAttribute = .forceRightToLeft
        }
        
        languages_tableview.delegate = self
        languages_tableview.dataSource = self
    }
    

    @IBAction func bckbtn_clk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout_clk(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "User")
        //navigationController?.popToRootViewController(animated: true)
        (UIApplication.shared.delegate as! AppDelegate).restartApp()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CitiesCell = languages_tableview.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
        
        if Locale.preferredLanguages[0] == "en"{
            cell.top_container.semanticContentAttribute = .forceRightToLeft
        }
        else{
            cell.top_container.semanticContentAttribute = .forceLeftToRight
        }
        
        cell.config(_obj: languages[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
            // When download completes,control flow goes here.
            
                for i in 0 ..< self.languages.count {
                    self.languages[i].isCheked = false
                }
                self.langaugeId = self.languages[indexPath.row].id!
                self.languages[indexPath.row].isCheked = true
                self.languages_tableview.reloadData()
            
            if(indexPath.row == 0){
//                let langCultureCode: String = "ar"
//                let defaults = UserDefaults.standard
//                defaults.set([langCultureCode], forKey: "AppleLanguages")
//                defaults.synchronize()
                UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
                
                UserDefaults.standard.set("ar", forKey: "Locale")
                //Bundle.setLanguage("ar-EG")
                //L10n.shared.language = "ar"
            }
            else{
//                let langCultureCode: String = "en"
//                let defaults = UserDefaults.standard
//                defaults.set([langCultureCode], forKey: "AppleLanguages")
//                defaults.synchronize()
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                
                
                UserDefaults.standard.set("en", forKey: "Locale")
                //Bundle.setLanguage("en")
                //L10n.shared.language = "en"
            }
            //set app langauge
            //(UIApplication.shared.delegate as! AppDelegate).restartApp()
            //self.navigationController?.popToRootViewController(animated: true)'
            UserDefaults.standard.synchronize()
            displayToastMessage(Bundle.main.localizedString(forKey: "need-restart", value: nil, table: "Default"))
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
