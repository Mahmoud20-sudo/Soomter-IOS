//
//  RegTypeVC.swift
//  Soomter
//
//  Created by Mahmoud on 7/31/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class RegTypeVC: UIViewController {

    @IBAction func bckbtn_clk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var person_btn: UIButton!
    @IBOutlet weak var inst_btn: UIButton!
    @IBOutlet weak var bck_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        person_btn.roundedWithBorder()
        inst_btn.roundedWithBorder()
        
        person_btn.setTitleColor(hexStringToUIColor(hex: "#ECD493"), for: UIControlState.normal)
        inst_btn.setTitleColor(hexStringToUIColor(hex: "#ECD493"), for: UIControlState.normal)
        
        let pre = Locale.preferredLanguages[0]
        if pre == "en"{
            
            bck_btn.transform = bck_btn.transform.rotated(by: CGFloat(Double.pi))
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func instbtn_clk(_ sender: UIButton) {
    }
    @IBAction func persbtn_clk(_ sender: UIButton) {
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
