//
//  NofticiationsCell.swift
//  Soomter
//
//  Created by Mahmoud on 9/23/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit

class NofticiationsCell: UITableViewCell {

    @IBOutlet weak var period_time_tf: UITextField!
    @IBOutlet weak var name_tf: UILabel!
    @IBOutlet weak var period_date_tf: UITextField!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var img: UIImageView!
    
    func config(_obj: NotificationsData.Items){        name_tf.text = _obj.ShortMessageBody
        
        if let url =  _obj.Image{
            img.kf.setImage(with: URL(string: url),
                                  placeholder: nil,
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
        }
        
        // input date in given format (as string)
        
        let inputDateAsString = _obj.CreateDate?.components(separatedBy: ".")

        // initialize formatter and set input date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        // read input date string as NSDate instance
        if let date = formatter.date(from: (inputDateAsString?[0])!) {
            
            // set locale to "ar_DZ" and format as per your specifications
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale!
            formatter.dateFormat = "EEEE yyyy/MM/d"
        
            period_date_tf.text = formatter.string(from: date) // الأربعاء, 9 مارس, 2016 10:33 ص
            formatter.dateFormat = "hh:mm a"
            period_time_tf.text = formatter.string(from: date) // الأربعاء, 9 مارس, 2016 10:33 ص
        }
    }

    
    
    override func layoutIfNeeded() {
        container.roundedWithBorder(radius: 10)
    }
}

