//
//  GroupedMenuVC.swift
//  Soomter
//
//  Created by Mahmoud on 9/19/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

struct Section {
    var name: String
    var img: String
    var childs: [ProductCatgsTreeData.Childs]
    var collapsed: Bool
    
    init(name: String, img: String, childs: [ProductCatgsTreeData.Childs], collapsed: Bool = true) {
        self.name = name
        self.img = img
        self.childs = childs
        self.collapsed = collapsed
    }
}



class GroupedMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sections = [Section]()
    
    var catgsList : [ProductCatgsTreeData.Result] = []
    
    @IBOutlet weak var grouped_tableview: UITableView!
    
    @IBOutlet weak var viewTopCon: NSLayoutConstraint!
//    override func viewDidLayoutSubviews()
//    {
//
//        if(deviceWidthSE)
//        {
//            self.viewTopCon.constant = 75
//        }
//        else
//            if(deviceWidth8)
//            {
//                self.viewTopCon.constant = 85
//            }
//            else
//                if(deviceWidth8Plus)
//                {
//                    self.viewTopCon.constant = 105
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = hexStringToUIColor(hex: "#191919" , alpha : 0.0)
        
        print(catgsList)
        for item in catgsList {
            sections.append(Section(name: item.Name ?? "" , img: item.Image!
                , childs: item.Childs!))
        }
        
        grouped_tableview.delegate = self
        grouped_tableview.dataSource = self
        //self.grouped_tableview.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0)

        
        self.grouped_tableview.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        
        // For section 1, the total count is items count plus the number of headers
        var count = sections.count
        
        for section in sections {
            count += section.childs.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return 50.0
        }
        
        return sections[section].collapsed ? 0 : 44.0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as UITableViewCell!
//            cell?.textLabel?.text = "Apple"
//            return cell!
//        }
        
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            //let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! HeaderCell
             let cell: HeaderCell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
            cell.title_lbl
                .text = sections[section].name
            cell.toggleBtn.tag = section
            cell.toggleBtn.setTitle(sections[section].collapsed ? "+" : "-", for: .normal)
            cell.toggleBtn.addTarget(self, action: #selector(GroupedMenuVC.toggleCollapse), for: .touchUpInside)
           
            if let img =  URL(string: sections[section].img){
                cell.img.kf.setImage(with: img,
                                      placeholder: nil,
                                      options: [.transition(.fade(1))],
                                      progressBlock: nil,
                                      completionHandler: nil)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdsStatCell
            cell.name_lbl?.text = sections[section].childs[row - 1].Name
            cell.name_lbl?.textColor = UIColor.white
            cell.img.isHidden = true
            return cell
        }
    }
    
    func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + sections[section].childs.count
        
        grouped_tableview.beginUpdates()
        for i in start ..< end + 1 {
            grouped_tableview.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
        }
        grouped_tableview.endUpdates()
    }
    
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.childs.count + 1
        }
        
        return indices
    }
}
