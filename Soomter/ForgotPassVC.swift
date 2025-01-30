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
import Alamofire
import JGProgressHUD

class ForgotPassVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var languages_tableview: UITableView!
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var input_Feild: UITextField!
    
    @IBOutlet weak var method_Tableview: UITableView!
    @IBOutlet weak var send_btn: UIButton!
    var methods : [CitiesData.Result] = []
    
    var forgots : [CitiesData.Result] = []
    
    var methodsList : [String] = []
    var forgotsList : [String] = []
    
    var langaugeId = 0
    var methodType = 0
    
    var hud : JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        
       // if Locale.preferredLanguages[0] == "en"{
        
            forgotsList = [Bundle.main.localizedString(forKey: "forgot_username", value: nil, table: "Default") ,
                       Bundle.main.localizedString(forKey: "forgot_pass", value: nil, table: "Default")]
        
            methodsList = [Bundle.main.localizedString(forKey: "email_method", value: nil, table: "Default") ,
                       Bundle.main.localizedString(forKey: "mobile_method", value: nil, table: "Default")]
       // }
//        else{
//            forgotsList = ["نسيت كلمة المرور" ,"نسيت اسم المستخدم"]
//
//            forgotsList = ["إرسال رسالة عبر الجوال","عن طريق البريد الألكتروني"]
//        }
        method_Tableview.delegate = self
        method_Tableview.dataSource = self
        
        languages_tableview.delegate = self
        languages_tableview.dataSource = self
        
        send_btn.roundedWithBorder(radius: 8)
        input_Feild.roundedWithBorder(radius: 12)
        
        send_btn.isHidden = false
        
        for var i in 0..<forgotsList.count{
            
            let rsultObj = CitiesData.Result(name: forgotsList[i], id: i + 1, isChekced: false)
            forgots.append(rsultObj)
        }
        
        for var i in 0..<methodsList.count{
            
            let rsultObj = CitiesData.Result(name: methodsList[i], id: i + 1, isChekced: false)
            methods.append(rsultObj)
        }
        
        if Locale.preferredLanguages[0] != "en"{
            
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
        languages_tableview.roundedWithBorder(radius: 5)
        method_Tableview.roundedWithBorder(radius: 5)
    }
    
    
    @IBAction func bckbtn_clk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout_clk(_ sender: UIButton) {

        if input_Feild.text == ""{
            displayToastMessage(Bundle.main.localizedString(forKey: "fill-rq-field", value: nil, table: "Default"))
            return
        }
        
        if !validateEmail(enteredEmail: input_Feild.text!){
            displayToastMessage(Bundle.main.localizedString(forKey: "invalid-mail", value: nil, table: "Default"))
            return
        }
        
        if langaugeId == 0 {
            displayToastMessage(Bundle.main.localizedString(forKey: "choose-type", value: nil, table: "Default"))
            return
        }
        
        if methodType == 0 {
            displayToastMessage(Bundle.main.localizedString(forKey: "choose-method", value: nil, table: "Default"))
            return
        }
        
        hud.show(in: self.view)
        
        let parameters: Parameters = [
            "Type": langaugeId,
            "Email": input_Feild.text!,
            "Method": methodType
        ]
        
        Alamofire.request(FORGOT_PASS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization //result
                self.hud.dismiss()
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //    print("JSON: \(json)") // serialized json response
                        
                       // let regModel = Mapper<CompRegModel>().map(JSONObject: json)
                        //print(user)
                        //if regModel?.result?.Message == "0001" {
                        
                        print(json)
                        
                        displayToastMessage(Bundle.main.localizedString(forKey: "process-sucess", value: nil, table: "Default"))
                            self.navigationController?.popViewController(animated: true)
                        //}
                        //else
                        //{])
                        //}
                    }
                    break
                case .failure(let error):
                    displayToastMessage(error.localizedDescription)
                    break
                }
                //            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //                print("Data: \(utf8Text)") // original server data as UTF8 string
                //            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CitiesCell = languages_tableview.dequeueReusableCell(withIdentifier: "CitiesCell") as! CitiesCell
        
        if Locale.preferredLanguages[0] == "en" {
            cell.top_container.semanticContentAttribute = .forceRightToLeft
            
        }
        else{
            cell.top_container.semanticContentAttribute = .forceLeftToRight
        }
        
        if tableView == languages_tableview{
        
            cell.config(_obj: forgots[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
            // When download completes,control flow goes here.
            
            for i in 0 ..< self.forgots.count {
                self.forgots[i].isCheked = false
            }
                
                if(indexPath.row == 0){
                    self.langaugeId = 1
                }
                else{
                    self.langaugeId = 2
                }
            self.forgots[indexPath.row].isCheked = true
            self.languages_tableview.reloadData()
           
        })
            
        }
        else{
            cell.config(_obj: methods[indexPath.row], _position: indexPath.row, completionHander: { (success) -> Void in
                // When download completes,control flow goes here.
                
               
                self.input_Feild.text = ""
                if(indexPath.row == 0){
                    self.methodType = 1
                    self.input_Feild.placeholder = Bundle.main.localizedString(forKey: "email", value: nil, table: "Default")
                    self.input_Feild.textContentType = UITextContentType.emailAddress
                }
                else{
                    
                    self.methodType = 2
                    self.input_Feild.placeholder = Bundle.main.localizedString(forKey: "mob", value: nil, table: "Default")
                    self.input_Feild.textContentType = UITextContentType.telephoneNumber
                }
                
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
