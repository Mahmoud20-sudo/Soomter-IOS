//
//  Child2VC.swift
//  Soomter
//
//  Created by Mahmoud on 8/28/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import ObjectMapper

class Child2VC: UIViewController , IndicatorInfoProvider , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var adImg: UIImageView!
    @IBOutlet weak var option_icon: UIImageView!
    @IBOutlet weak var adsCV: UICollectionView!
    @IBOutlet weak var serch_icon: UIImageView!
    @IBOutlet weak var serch_container: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var catId = 0
    var cityId = 0
    var typeId = 0
    
    var adsData : AdsData.Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTF.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        searchTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        serch_container.roundedWithBorder(radius: 15)
        // Do any additional setup after loading the view.
        option_icon.image = option_icon.image!.withRenderingMode(.alwaysTemplate)
        option_icon.tintColor = hexStringToUIColor(hex: "#8E8E93")
        serch_icon.image = serch_icon.image!.withRenderingMode(.alwaysTemplate)
        serch_icon.tintColor = hexStringToUIColor(hex: "#8E8E93")
        // Do any additional setup after loading the view.
        
        if Locale.preferredLanguages[0] != "en"{
            serch_icon.transform = serch_icon.transform.rotated(by: CGFloat(Double.pi / 2))
            adsCV.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        
        adsCV.delegate = self
        adsCV.dataSource = self
        
        
        option_icon.isUserInteractionEnabled = true
        let gestureSwift2AndHigher = UITapGestureRecognizer(
            target: self, action:  #selector (self.navigateToSearchScreen(_:)))
        option_icon.addGestureRecognizer(gestureSwift2AndHigher)
        
        getTopDwonAds()
    }
    
    func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            getAds()
        }
    }
    
    func enterPressed(){
        //do something with typed text if needed
        searchTF.resignFirstResponder()
        getAds()
    }

    func getAds(){
        let parameters: Parameters = [
            "Lang": Locale.preferredLanguages[0],
            "Title": searchTF.text ?? "",
            "CategoryId": catId,
            "AdsTo": 0,
            "CityId": cityId,
            "Count": 200,
            "Type": typeId
        ]
        
        print(parameters)
        
        Alamofire.request(ADS_URL , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                // print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //   print(json)
                        let obj = Mapper<AdsData>().map(JSONObject: json)
                        
                        self.adsData = obj?.result
                        
                        self.adsCV.reloadData()
                        
                    }
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    
    func getTopDwonAds(){
        let parameters: Parameters = [
            "PlaceId": 4
        ]
        
        Alamofire.request(TOP_DOWN_ADS , method : .post, parameters :
            parameters , encoding: JSONEncoding.default).responseJSON { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                // print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                switch response.result{
                case .success:
                    if let json = response.result.value {
                        //   print(json)
                        let obj = Mapper<TopDownAdsData>().map(JSONObject: json)
                        
                        self.adImg.kf.setImage(with: URL(string: (obj?.result?.Image)!),
                                               placeholder: nil,
                                               options: [.transition(.fade(1))],
                                               progressBlock: nil,
                                               completionHandler: nil)
                    }
                    
                    break
                case .failure(let error):
                    //self.progressView.isHidden = true
                    displayToastMessage(error.localizedDescription)
                    break
                }
        }
    }

    
    func navigateToSearchScreen(_ sender:UITapGestureRecognizer)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:
            "AdsSearchVC") as! AdsSearchVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  25
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/2.2)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Bundle.main.localizedString(forKey: "photo-ads", value: nil, table: "Default"))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adsDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        
        adsDetailsVC.adObject = adsData?.ImageAds?[indexPath.row]
        
        navigationController?.pushViewController(adsDetailsVC, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (adsData?.ImageAds?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCell
        
       // print(adsData?.ImageAds?[indexPath.row].Title)
        cell.config(_Obj: (adsData?.ImageAds?[indexPath.row])!)
        
        if Locale.preferredLanguages[0] == "en"{
            cell.bottom_view.semanticContentAttribute = .forceRightToLeft
        }
        else{
            
            cell.bottom_view.semanticContentAttribute = .forceRightToLeft
        }
        cell.roundedWithBorder(radius: 5)
        
        return cell
        
    }
}
