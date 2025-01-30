//
//  CountriesVC.swift
//  Soomter
//
//  Created by Mahmoud on 7/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class CountriesVC: UIViewController {

    @IBOutlet weak var uae: UIView!
    @IBOutlet weak var kuwait: UIView!
    @IBOutlet weak var ksa: UIView!
    
    @IBOutlet weak var choose_lbl: UILabel!
    @IBOutlet weak var kwuait_lbl: UILabel!
    @IBOutlet weak var uae_lbl: UILabel!
    @IBOutlet weak var ksa_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uae.roundedWithBorder()
        kuwait.roundedWithBorder()
        ksa.roundedWithBorder()
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToLogin(_:)))
        ksa.addGestureRecognizer(gestureSwift2AndHigher)
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToLogin(_:)))
        
        kuwait.addGestureRecognizer(gestureSwift2AndHigher2)
        // Do any additional setup after loading the view.
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(target: self, action:  #selector (self.navigateToLogin(_:)))
        uae.addGestureRecognizer(gestureSwift2AndHigher3)
        
        if Locale.preferredLanguages[0] == "en"{
            uae.semanticContentAttribute = .forceRightToLeft
            ksa.semanticContentAttribute = .forceRightToLeft
            kuwait.semanticContentAttribute = .forceRightToLeft
        }

    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // or for Swift 3
    func navigateToLogin(_ sender:UITapGestureRecognizer){
        let newViewController = LoginVC()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
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
