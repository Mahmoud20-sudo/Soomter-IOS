//
//  InistRegVC.swift
//  Soomter
//
//  Created by Mahmoud on 8/1/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class InistRegVC: UIViewController {

    @IBOutlet weak var name2: UITextField!
    @IBOutlet weak var name1: UITextField!
    @IBOutlet weak var mobile_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var pass_input: UITextField!
    @IBOutlet weak var reg_btn: UIButton!
    @IBOutlet weak var bck_btn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var prnt_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollview.backgroundColor = UIColor(patternImage: UIImage(named: "login-background.png")!)

        reg_btn.roundedWithBorder()
        setBottomBorder(field: email_input)
        setBottomBorder(field: pass_input)
        setBottomBorder(field: name1)
        setBottomBorder(field: username_input)
        setBottomBorder(field: mobile_input)
        setBottomBorder(field: name2)
        
        let pre = Locale.preferredLanguages[0]
        if pre == "en"{
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
        }
        
        reg_btn.setTitleColor(hexStringToUIColor(hex: "#ECD493"), for: UIControlState.normal)
        
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
    
    @IBAction func regbtn_clk(_ sender: UIButton) {
        let pass = pass_input.text
        let email = email_input.text
        let nameEng = name1.text
        let nameArb = name2.text
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
        if (nameEng?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }
        if (nameArb?.isEmpty)!
        {
            displayToastMessage("Fill all fields!")
            return
        }

        //print(Locale.current.languageCode!)
        register(_userName: username!, _pass: pass! , _lang: Locale.current.languageCode!, _nameAr :name2.text! ,
                 _nameEng :name1.text!, _mobile: mobile_input.text! , _email: email_input.text!)
    }
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func register(_userName : String , _pass : String
        ,_lang: String , _nameAr : String , _nameEng : String , _mobile : String, _email :String){
        let parameters: Parameters = [
            "Username": _userName,
            "Password": _pass,
            "Lang": _lang,
            "TitleAr": _nameAr,
            "TitleEn": _nameEng,
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
        Alamofire.request(REG_COMP_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
              // print("Request: \(String(describing: response.request))")   // original url request
               // print("Response: \(String(describing: response.response))") // http url response
               // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                     //   print("JSON: \(json)") // serialized json response
                        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
