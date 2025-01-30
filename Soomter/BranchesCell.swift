//
//  BranchesCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/18/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class BranchesCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var height_constrains: NSLayoutConstraint!
    @IBOutlet weak var infrms_tv: UITableView!
    @IBOutlet weak var branch_name_lbl: UILabel!
    
    var informList : [Informations] = []
    
    override func awakeFromNib() {
        self.infrms_tv.delegate = self
        self.infrms_tv.dataSource = self
        infrms_tv.roundedWithBorder(radius: 8)
    }
    
    func config(_obj: CompanyProfileData.BranchsCompany){
        branch_name_lbl.text = _obj.BranchName
        if let address = _obj.BranchAddress {
            let obje = Informations(title: Bundle.main.localizedString(forKey: "address", value: nil, table: "Default"), value: address)
            self.informList.append(obje)
        }
        if let mob = _obj.BranchMobile {
            let obje = Informations(title: Bundle.main.localizedString(forKey: "mob", value: nil, table: "Default"), value: mob)
            self.informList.append(obje)
        }
        if let phone = _obj.BranchPhone {
            let obje = Informations(title: Bundle.main.localizedString(forKey: "phone", value: nil, table: "Default"), value: phone)
            self.informList.append(obje)
        }
        if let fax = _obj.BranchFax {
            let obje = Informations(title: Bundle.main.localizedString(forKey: "fax", value: nil, table: "Default"), value: fax)
            self.informList.append(obje)
        }
        
        self.infrms_tv.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InformsCell = tableView.dequeueReusableCell(withIdentifier: "InformsCell") as! InformsCell
        cell.config(obje: informList[indexPath.row])
        
                return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
//        height_constrains.constant = infrms_tv.contentSize.height
//        infrms_tv.layoutIfNeeded()
//        self.layoutIfNeeded()
    }
}
