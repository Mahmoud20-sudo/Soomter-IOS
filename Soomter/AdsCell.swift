//
//  AdsCell.swift
//  Soomter
//
//  Created by Mahmoud on 8/27/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//

import UIKit
import AVKit

class AdsCell: UICollectionViewCell {
    
    @IBOutlet weak var play_icon: UIImageView?
    @IBOutlet weak var ad_image: UIImageView!
//    @IBOutlet weak var play_img: UIImageView!
    @IBOutlet weak var fav_img: UIImageView!
    @IBOutlet weak var ad_txt: UILabel!
    
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var more_lbl: UILabel?
    @IBOutlet weak var summary_lbl: UILabel?
    var videoUrl = ""
    
    func config(_Obj : AdsData.AdsClass){
        ad_txt.text = _Obj.Title 

        if Locale.preferredLanguages[0] == "en" {
            fav_img.image = _Obj.IsIdentified! > 0 ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_img.image = _Obj.IsIdentified! > 0  ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }
        
        if _Obj.type == 3 {
            if let videoId = _Obj.VedioUrl {
                videoUrl = videoId
                if let url = URL(string: getRightUrl(inputID: videoId)){
                ad_image.kf.setImage(with: url,
                                     placeholder: nil,
                                     options: [.transition(.fade(1))],
                                     progressBlock: nil,
                                     completionHandler: nil)
                }
            }
            play_icon?.isHidden = false
            play_icon?.isUserInteractionEnabled = true
            ad_image.isUserInteractionEnabled = true
            let gestureSwift2AndHigher2 = UITapGestureRecognizer( target: self, action:  #selector (self.playVideo(_:)))
            
            play_icon?.addGestureRecognizer(gestureSwift2AndHigher2)
            //ad_image.addGestureRecognizer(gestureSwift2AndHigher2)
        }
        else {
            if let url = URL(string: _Obj.Image!){
                ad_image.kf.setImage(with: url,
                                     placeholder: nil,
                                     options: [.transition(.fade(1))],
                                     progressBlock: nil,
                                     completionHandler: nil)
            }
        }

        
    }
    
    func playVideo(_ sender:UITapGestureRecognizer)  {
        if let url = URL(string: videoUrl){
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            
            //            let player = AVPlayer(url: url)
            //
            //            let avPlayerController = AVPlayerViewController()
            //
            //            avPlayerController.player = player;
            //            var frame = CGRect(x: self.view.bounds.midX / 2, y: self.view.bounds.midY / 2, width: self.view.frame.width / 2, height: self.view.frame.height / 2)
            //            avPlayerController.view.frame = frame ;
            //            avPlayerController.player?.play()
            //            self.addChildViewController(avPlayerController)
            //            self.view.addSubview(avPlayerController.view);
        }
        else{
            displayToastMessage("Not supported")
        }
    }
    
    func config2(_Obj : AdDetailsData.Result.SimilarAds){
        ad_txt.text = _Obj.Title
      
        
        if Locale.preferredLanguages[0] == "en" {
            fav_img.image = _Obj.IsFavorite! > 0 ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_img.image = _Obj.IsFavorite! > 0  ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }

        
        if _Obj.type == 3 {
            if let videoId = _Obj.VedioUrl {
                videoUrl = videoId
                if let url = URL(string: getRightUrl(inputID: videoId)){
                    ad_image.kf.setImage(with: url,
                                         placeholder: nil,
                                         options: [.transition(.fade(1))],
                                         progressBlock: nil,
                                         completionHandler: nil)
                }
            }
            play_icon?.isHidden = false
            play_icon?.isUserInteractionEnabled = true
            ad_image.isUserInteractionEnabled = true
            let gestureSwift2AndHigher2 = UITapGestureRecognizer( target: self, action:  #selector (self.playVideo(_:)))
            
            play_icon?.addGestureRecognizer(gestureSwift2AndHigher2)
            //ad_image.addGestureRecognizer(gestureSwift2AndHigher2)
        }
        else {
            if let urlString = _Obj.Image{
                if let url = URL(string: urlString){
                ad_image.kf.setImage(with: url,
                                     placeholder: nil,
                                     options: [.transition(.fade(1))],
                                     progressBlock: nil,
                                     completionHandler: nil)
                }
            }
        }
        
    }
    
    func config3(_Obj : CompanyProfileData.SimilarCompanies){
        ad_txt.text = _Obj.CompanyName
        summary_lbl?.text = _Obj.Summary
        more_lbl?.roundedWithBorder(radius: 5)
        if Locale.preferredLanguages[0] == "en" {
            fav_img.image = _Obj.IsIdentified! ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_img.image = _Obj.IsIdentified!  ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }
    
//        if let url = URL(string: _Obj.Image!){
//                ad_image.kf.setImage(with: url,
//                                     placeholder: nil,
//                                     options: [.transition(.fade(1))],
//                                     progressBlock: nil,
//                                     completionHandler: nil)
//            }
//        }
        
    }

    func config4(_Obj : CompanyProfileData.ListAds){
        ad_txt.text = _Obj.Title
        
        
        if Locale.preferredLanguages[0] == "en" {
            fav_img.image = _Obj.IsFavorite! > 0 ? UIImage(named: "flipped-fav-on-Icon.png") : UIImage(named: "flipped-fav-off-Icon.png")
        }else{
            fav_img.image = _Obj.IsFavorite! > 0  ? UIImage(named: "fav-on-corner-Icon.png") : UIImage(named: "unactive-fav-Icon.png")
        }
        
        
        if _Obj.IsVedioAds! {
            if let videoId = _Obj.VedioUrl {
                videoUrl = videoId
                if let url = URL(string: getRightUrl(inputID: videoId)){
                    ad_image.kf.setImage(with: url,
                                         placeholder: nil,
                                         options: [.transition(.fade(1))],
                                         progressBlock: nil,
                                         completionHandler: nil)
                }
            }
            play_icon?.isHidden = false
            play_icon?.isUserInteractionEnabled = true
            ad_image.isUserInteractionEnabled = true
            let gestureSwift2AndHigher2 = UITapGestureRecognizer( target: self, action:  #selector (self.playVideo(_:)))
            
            play_icon?.addGestureRecognizer(gestureSwift2AndHigher2)
            //ad_image.addGestureRecognizer(gestureSwift2AndHigher2)
        }
        else {
            if let url = URL(string: "https://soomter.com/AttachmentFiles/\(_Obj.ImageId).png"){
                ad_image.kf.setImage(with: url,
                                     placeholder: nil,
                                     options: [.transition(.fade(1))],
                                     progressBlock: nil,
                                     completionHandler: nil)
            }
        }
        
    }


    override func layoutSubviews() {
        
//        self.dropShadow(color: hexStringToUIColor(hex: "#E9E9E9"), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
        
    }
}
