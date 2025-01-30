//
//  OwnCompVC.swift
//  Soomter
//
//  Created by Mahmoud on 10/25/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

//
//  ModalViewController.swift
//  BlurredBackgroundSemiTransparentView
//
//  Created by Mohau Mpoti on 19/9/17.
//  Copyright © 2017 Swift Tutorials. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}
class OwnCompVC: UIViewController , UITextViewDelegate , UITextFieldDelegate {
    
    weak var delegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var name_tf: UITextField!
    
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var details_tv: UITextView!
    @IBOutlet weak var mobile_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    
    var obj : CompanyProfileData.Result?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    @IBAction func sendbtn_clk(_ sender: UIButton) {
        var isValid = true
        if name_tf.text == nil || (name_tf.text?.isEmpty)!{
            name_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if mobile_tf.text == nil {
            mobile_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if email_tf.text == nil {
            email_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if details_tv.text == nil {
            details_tv.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if isValid{
            let name = name_tf.text
            let mob = mobile_tf.text
            let emil = email_tf.text
            let det = details_tv.text
            ownCompany(name: name!,
                       mobile: mob!, email: emil!, reqDetails: det!)
        }
    }
    
    override func viewDidLoad() {
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
    
    
    override func viewDidLayoutSubviews() {
        //view.backgroundColor = UIColor.clear
        view.isOpaque = false
        //ensure that the icon embeded in the cancel button fits in nicely
        cancelButton.imageView?.contentMode = .scaleAspectFit
        mobile_tf.textContentType = UITextContentType.telephoneNumber
        email_tf.textContentType = UITextContentType.emailAddress
        container.roundedWithBorder(radius: 10)
        send_btn.roundedWithBorder(radius: 8)
        details_tv.roundedWithBorder(radius: 8)
        //add a white tint color for the Cancel button image
        let cancelImage = UIImage(named: "Close-Icon")
        
        let tintedCancelImage = cancelImage?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(tintedCancelImage, for: .normal)
        cancelButton.tintColor = hexStringToUIColor(hex: "#D9B878")
        
        self.name_tf.delegate = self
        self.mobile_tf.delegate = self
        self.email_tf.delegate = self
        self.details_tv.delegate = self

    }
    
    func ownCompany(name: String, mobile: String, email: String, reqDetails: String){
        
        //if// {
        let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
        let user = Mapper<User>().map(JSONObject: recovedUserJson)
            
            let parameters: Parameters = [
                "CompanyId": obj?.Id,
                "UserId": user?.result?.id ?? "",
                "Name": name,
                "Mobile": mobile,
                "Email": email,
                "RequestDetails": reqDetails,
            ]
            
            Alamofire.request(SEND_GENERAL_COMPANY , method : .post, parameters :
                parameters , encoding: JSONEncoding.default).responseJSON { response in
                    // print("Request: \(String(describing: response.request))")   // original url request
                    // print("Response: \(String(describing: response.response))") // http url response
                    // print("Result: \(response.result)")                         // response serialization result
                    switch response.result{
                    case .success:
                        if let json = response.result.value {
                            //      print("JSON: \(json)") // serialized json response
                            //self.ow.isHidden = true
                            
                            displayToastMessage("Successfully followed")
                        }
                        break
                    case .failure(let error):
                        displayToastMessage(error.localizedDescription)
                        break
                    }
            }
        //}
        //else{
         //   let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
         //   displayToastMessage(msg)
          //  return
       // }
    }
}
extension UITextField {
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}
extension UITextView{
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}
