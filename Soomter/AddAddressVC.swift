//
//  OwnCompVC.swift
//  Soomter
//
//  Created by Mahmoud on 10/25/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
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
import BEMCheckBox
import iOSDropDown

class AddAddressVC: UIViewController {
    
    weak var delegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var name_tf: UITextField!
    
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var details_tv: UITextView!
    
    @IBOutlet weak var mobile_tf: UITextField!
    
    @IBOutlet weak var buildingNumber_tf: UITextField!
    
    @IBOutlet weak var specialMark_tf: UITextField!
    @IBOutlet weak var streetNo_tf: UITextField!
    @IBOutlet weak var area_tf: UITextField!
    
    @IBOutlet weak var dropDown: DropDown!

    var obj : CompanyProfileData.Result?
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    @IBAction func sendbtn_clk(_ sender: UIButton) {
        var isValid = true
        if cityid == 0{
            dropDown.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if name_tf.text == nil || (name_tf.text?.isEmpty)!{
            name_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if mobile_tf.text == nil {
            mobile_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if area_tf.text == nil {
            area_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if streetNo_tf.text == nil {
            streetNo_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if buildingNumber_tf.text == nil {
            buildingNumber_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if specialMark_tf.text == nil {
            specialMark_tf.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if details_tv.text == nil {
            details_tv.isError(baseColor: hexStringToUIColor(hex: "#EFF0F3").cgColor, numberOfShakes: 3, revert: true)
            isValid = false
        }
        if isValid{
            let name = name_tf.text
            let mob = mobile_tf.text
            let det = details_tv.text
            let area = area_tf.text
            let buildNumb = buildingNumber_tf.text
            let streetNumb = streetNo_tf.text
            let mark = specialMark_tf.text
            
            addAddress(name: name!,
                       mobile: mob! ,area : area!, streetNumb: streetNumb!, buildNumb: buildNumb!,
                       mark: mark!, reqDetails: det!)
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
        
        checkBox.setOn(false, animated: true)
        
        buildingNumber_tf.textContentType = UITextContentType.telephoneNumber
        streetNo_tf.textContentType = UITextContentType.telephoneNumber
        
        container.roundedWithBorder(radius: 10)
        send_btn.roundedWithBorder(radius: 8)
        details_tv.roundedWithBorder(radius: 8)
        //add a white tint color for the Cancel button image
        let cancelImage = UIImage(named: "Close-Icon")
        
        let tintedCancelImage = cancelImage?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(tintedCancelImage, for: .normal)
        cancelButton.tintColor = hexStringToUIColor(hex: "#D9B878")
        
        if let recovedUserJsonData2 = UserDefaults.standard.object(forKey: "CITIES")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData2 as! Data)
            let cities = Mapper<CitiesData>().map(JSONObject: recovedUserJson)!
            var citiesList = cities.result!
            for var i in 0..<citiesList.count {
                dropDown.optionArray.append(citiesList[i].name!)
                dropDown.optionIds?.append(citiesList[i].id!)
            }
            
        }
        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
         //   self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
            self.cityid = id
        }
    }
    
    var cityid = 0
    
    func addAddress(name: String, mobile: String ,area: String, streetNumb : String,buildNumb:String ,mark: String,reqDetails: String){
        
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            
            let parameters: Parameters = [
                "ReceiverName": name,
                "UserId": user!.result!.id!,
                "Address": reqDetails,
                "ContactTel": mobile,
                "CityId": mobile,
                "IsDefault": checkBox.on ? true : false,
                "Region": area,
                "StreetNo": streetNumb,
                "FloorNo": buildingNumber_tf,
                "Trademark": mark,
                ]
            
            
            Alamofire.request(ADD_ADDRESS_URL , method : .post, parameters :
                parameters , encoding: JSONEncoding.default).responseJSON { response in
                    // print("Request: \(String(describing: response.request))")   // original url request
                    // print("Response: \(String(describing: response.response))") // http url response
                    // print("Result: \(response.result)")                         // response serialization result
                    switch response.result{
                    case .success:
                        if let json = response.result.value {
                            //      print("JSON: \(json)") // serialized json response
                            //self.ow.isHidden = true
                            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
                            displayToastMessage(msg)
                        }
                        break
                    case .failure(let error):
                        displayToastMessage(error.localizedDescription)
                        break
                    }
            }
        }
        else{
            let msg = Bundle.main.localizedString(forKey: "need_login", value: nil, table: "Default")
            displayToastMessage(msg)
            return
        }
    }
    @IBAction func selectitem_clk(_ sender: BEMCheckBox) {
        if (checkBox.on == false){
                    checkBox.setOn(false, animated: true)
                }else{
                   checkBox.setOn(true, animated: true)
               }
        
            
    }

}
