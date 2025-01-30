//
//  AllCatgsVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/3/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class AllCatgsVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var catgs_cv: UICollectionView!
    @IBOutlet weak var bck_btn: UIButton!
    
    var portalCatsList : [PortalBussinsCatgsData.Result] = []
    
    @IBAction func settingsbtn_clk(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Locale.preferredLanguages[0] != "en"{
           //bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
        }

        catgs_cv.delegate = self
        catgs_cv.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func bckbtn_clk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatgsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatgsCell", for: indexPath) as! CatgsCell
        
        cell.config(_obj: portalCatsList[indexPath.row])
        cell.roundedWithBorder(radius: 8)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let companiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
        
        companiesVC.catgID = portalCatsList[indexPath.row].id
        companiesVC.titleLbl =  Locale.preferredLanguages[0] == "en" ? portalCatsList[indexPath.row].EnglishName : portalCatsList[indexPath.row].Name
        
        navigationController?.pushViewController(companiesVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portalCatsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  25
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/2.8)
    }
}
