//
//  PersonRegVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/2/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PersonRegVC: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var engname_input: UITextField!
    @IBOutlet weak var arbname_input: UITextField!
    @IBOutlet weak var arblstnme_input: UITextField!
    @IBOutlet weak var englstnme_input: UITextField!
    @IBOutlet weak var mobile_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var pass_input: UITextField!
    @IBOutlet weak var reg_btn: UIButton!
    
    @IBOutlet weak var bck_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollview.backgroundColor = UIColor(patternImage: UIImage(named: "login-background.png")!)
        
        reg_btn.roundedWithBorder()
        setBottomBorder(field: email_input)
        setBottomBorder(field: pass_input)
        setBottomBorder(field: engname_input)
        setBottomBorder(field: username_input)
        setBottomBorder(field: mobile_input)
        setBottomBorder(field: arbname_input)
        setBottomBorder(field: arblstnme_input)
        setBottomBorder(field: englstnme_input)
        
        reg_btn.setTitleColor(hexStringToUIColor(hex: "#ECD493"), for: UIControlState.normal)
            
        let pre = Locale.preferredLanguages[0]
        if pre == "en"{
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func regbtn_clk(_ sender: UIButton) {
        
        let pass = pass_input.text
        let email = email_input.text
        let firstNameEng = engname_input.text
        let firstNameArb = arbname_input.text
        let lastNameEng = englstnme_input.text
        let lastNameArb = arblstnme_input.text
        let mobile = mobile_input.text
        let username = username_input.text
        
        if (username?.isEmpty)!
        {
            displayToastMessage("Type your username!")
            return
        }
        if (email?.isEmpty)!
        {
            displayToastMessage("Type your email!")
            return
        }
        if !validateEmail(enteredEmail: email!){
            displayToastMessage("Invalid email address!")
            return
        }
        if (pass?.isEmpty)!
        {
            displayToastMessage("Type your password!")
            return
        }
        if (mobile?.isEmpty)!
        {
            displayToastMessage("Type your mobile number!")
            return
        }
        if (firstNameEng?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }
        if (firstNameArb?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }
        if (lastNameEng?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }
        if (lastNameArb?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }
        
        register(_userName: username!, _pass: pass! , _lang: Locale.current.languageCode!, _nameAr :firstNameArb! ,
                 _nameEng :firstNameEng!
                 ,_lstNameEng: lastNameEng!,_lstNameArb:lastNameArb!
                 ,_mobile: mobile! , _email: email!)
    }

    func register(_userName : String , _pass : String
        ,_lang: String , _nameAr : String , _nameEng : String
        ,_lstNameEng : String, _lstNameArb : String
        , _mobile : String, _email :String){
        let parameters: Parameters = [
            "Username": _userName,
            "Password": _pass,
            "Lang": _lang,
            "FirstNameAr": _nameAr,
            "FirstNameEn": _nameEng,
            "LastNameAr": _lstNameArb,
            "LastNameEn": _lstNameEng,
            "Mobile": _mobile,
            "Email": _email
        ]
        
        //        "Status": 1,
        //        "Error": null,0002
        //        "Result": {
        //            "UserId": "902ff438-135a-4701-b37b-1e0fa4e592f6",
        //            "Message": "0001"
        //        }
        //print(parameters)
        Alamofire.request(PERSON_COMP_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
               // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization //result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                    //    print("JSON: \(json)") // serialized json response
                        
                        let regModel = Mapper<CompRegModel>().map(JSONObject: json)
                        //print(user)
                        if regModel?.result?.Message == "0001" {
                            
                            displayToastMessage("Registration success")
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            displayToastMessage("Error!")
                        }
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
}
