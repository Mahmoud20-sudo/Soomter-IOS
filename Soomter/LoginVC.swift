//
//  ViewController.swift
//  Soomter
//
//  Created by Mahmoud on 7/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import JGProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var bck_btn: UIButton!
    @IBOutlet weak var reg_lbl: UILabel!
    @IBOutlet weak var noaccount_lbl: UILabel!
    @IBOutlet weak var loginlater_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var forgetpass_lbl: UILabel!
    @IBOutlet weak var pass_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var welcome_lbl: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    var iconClick : Bool!
    var hud : JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        login_btn.roundedWithBorder()
        setBottomBorder(field: email_input)
        setBottomBorder(field: pass_input)
        
        forgetpass_lbl.textColor = hexStringToUIColor(hex: "#545456")
        loginlater_btn.roundedWithBorder(color: "#545456")
        noaccount_lbl.textColor = hexStringToUIColor(hex: "#545456")
        reg_lbl.textColor = hexStringToUIColor(hex: "#ECD493")

        loginlater_btn.setTitleColor(hexStringToUIColor(hex: "#545456"), for: UIControlState.normal)
        login_btn.setTitleColor(hexStringToUIColor(hex: "#ECD493"), for: UIControlState.normal)
        
        pass_input.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "show-password.png")
        imageView.image = image
        pass_input.rightView = imageView

        iconClick = true;
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.togglePassword(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureSwift2AndHigher)
        
        let regTypeGesture = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToRegScreen(_:)))
        reg_lbl.isUserInteractionEnabled = true
        reg_lbl.addGestureRecognizer(regTypeGesture)
        
        let pre = Locale.preferredLanguages[0]
        if pre != "en"{
            loginlater_btn.titleEdgeInsets = UIEdgeInsetsMake(-5,0,0,0)
            login_btn.titleEdgeInsets = UIEdgeInsetsMake(-5,0,0,0)
        }else{
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollview.isScrollEnabled = true
        
        let forgotPass = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToForgotPassScreen(_:)))
        forgetpass_lbl.isUserInteractionEnabled = true
        forgetpass_lbl.addGestureRecognizer(forgotPass)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width , height: 800)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scrollview.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        scrollview.contentInset = contentInset
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollview.contentInset = contentInset
//    }
//
    
    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func later_clk(_ sender: UIButton) {
    }
    
    @IBAction func login_clk(_ sender: UIButton) {
        let username = email_input.text
        let pass = pass_input.text
        if (username?.isEmpty)!
        {
            displayToastMessage("Type your email!")
            return
        }
//        if !validateEmail(enteredEmail: username!){
//            displayToastMessage("Invalid email address!")
//        }
        if (pass?.isEmpty)!
        {
            displayToastMessage("Type your password!")
            return
        }
        hud = JGProgressHUD(style: .light)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        view.endEditing(true)
        login(_userName: username!, _pass: pass!)
    
    }
    
    func login(_userName : String , _pass : String){
        let parameters: Parameters = [
            "Username": _userName,
            "Password": _pass
        ]
        
        Alamofire.request(LOGIN_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
           // print("Request: \(String(describing: response.request))")   // original url request
           // print("Response: \(String(describing: response.response))") // http url response
           // print("Result: \(response.result)")                         // response serialization result
                self.hud.dismiss()
                switch response.result{
                case .success:
                    if let json = response.result.value {
                       // print("JSON: \(json)") // serialized json response
                        let user = Mapper<User>().map(JSONObject: json)
                        //print(user)
                        if user?.result != nil {
                           
                            let myData = NSKeyedArchiver.archivedData(withRootObject: json)
                            UserDefaults.standard.set(myData, forKey: "User")
                            
                            super.performSegue(withIdentifier: "MainVC2", sender: nil)
                        }
                        else
                        {
                            displayToastMessage("Invalid ceredentials!")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func togglePassword(_ sender:UITapGestureRecognizer)  {
        if(iconClick == true) {
        pass_input.isSecureTextEntry = false
        iconClick = false
    } else {
        pass_input.isSecureTextEntry = true
        iconClick = true
        }
    }
    
    func navigateToRegScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegTypeVC") as! RegTypeVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func navigateToForgotPassScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
