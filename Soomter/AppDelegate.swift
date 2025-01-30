//
//  AppDelegate.swift
//  Soomter
//
//  Created by Mahmoud on 7/30/18.
//  Copyright © 2018 Mahmoud. All rights reserved.
//
extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
private var kBundleKey: UInt8 = 0

class BundleEx: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) {
            return (bundle as! Bundle).localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
    
}
extension Bundle {
    
    static let once: Void = {
        object_setClass(Bundle.main, type(of: BundleEx()))
    }()
    
    class func setLanguage(_ language: String?) {
        Bundle.once
        let isLanguageRTL = Bundle.isLanguageRTL(language)
        if (isLanguageRTL) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.synchronize()
        
        let value = (language != nil ? Bundle.init(path: (Bundle.main.path(forResource: language, ofType: "lproj"))!) : nil)
        objc_setAssociatedObject(Bundle.main, &kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    class func isLanguageRTL(_ languageCode: String?) -> Bool {
        return (languageCode != nil && Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft)
    }
    
}
extension String {
    func localized(lang:String) -> String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
    
import UIKit
import ObjectMapper
import ESTabBarController_swift
import L10n_swift
import HockeySDK
import IQKeyboardManagerSwift


extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    let esTabController = ESTabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BITHockeyManager.shared().configure(withIdentifier: "61b49ab4ddad4180bf7bdb8ddcd8ef37")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation() // This line is obsolete in the crash only builds
        IQKeyboardManager.shared.enable = true

        
        UIApplication.shared.statusBarView?.backgroundColor = .white
        if !UserDefaults.standard.bool(forKey: "isFirstTime"){
                    let langCultureCode: String = "en"
                    let defaults = UserDefaults.standard
                    defaults.set([langCultureCode], forKey: "AppleLanguages")
                    defaults.synchronize()
                    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                    Bundle.setLanguage("en")

                    UserDefaults.standard.set(true, forKey: "isFirstTime")
                    UserDefaults.standard.synchronize()
        }
        else{
            print(UserDefaults.standard.string(forKey: "Locale"))
            if UserDefaults.standard.string(forKey: "Locale") == "ar"{
                let langCultureCode: String = "ar"
                let defaults = UserDefaults.standard
                defaults.set([langCultureCode], forKey: "AppleLanguages")
                defaults.synchronize()
                 Bundle.setLanguage("ar-EG")
                
            }else{
                let langCultureCode: String = "en"
                let defaults = UserDefaults.standard
                defaults.set([langCultureCode], forKey: "AppleLanguages")
                defaults.synchronize()
                 Bundle.setLanguage("en")
            }
        }
        //CountriesVC
        restartApp()
        
        return true
    }
    
    open func restartApp(){
        if let recovedUserJsonData = UserDefaults.standard.object(forKey: "User")
        {
            let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            let user = Mapper<User>().map(JSONObject: recovedUserJson)
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainVC")
            
            if user == nil {
                //self.window?.rootViewController = loginViewController
                
                let navigationController = UINavigationController.init(rootViewController: loginViewController)
                navigationController.navigationBar.isHidden = true
                
                self.window?.rootViewController = navigationController
                
            }
            else{
                
                let v2 = storyboard.instantiateViewController(withIdentifier: "CompaniesVC") as! CompaniesVC
                let v3 = storyboard.instantiateViewController(withIdentifier: "TestVC")
                let v4 = storyboard.instantiateViewController(withIdentifier: "ProductsMainVC") as! ProductsMainVC
            
                let v5 = storyboard.instantiateViewController(withIdentifier: "CompanyProfileVC") as! CompanyProfileVC
                v5.userID = user?.result?.id ?? ""
                
                mainViewController.hidesBottomBarWhenPushed = true;
                
                mainViewController.tabBarItem = ESTabBarItem.init(title: Bundle.main.localizedString(forKey: "home", value: nil, table: "Default"), image: UIImage(named: "Home-Icon"), selectedImage: UIImage(named: "Home-Icon"))
                v2.tabBarItem = ESTabBarItem.init(title: Bundle.main.localizedString(forKey: "serch", value: nil, table: "Default"), image: UIImage(named: "Search-Menu-Icon"), selectedImage: UIImage(named: "Search-Menu-Icon"))
                v3.tabBarItem = ESTabBarItem.init(title: Bundle.main.localizedString(forKey: "notifs", value: nil, table: "Default"), image: UIImage(named: "Notifications-Active-Icon"), selectedImage: UIImage(named: "Notifications-Active-Iconn"))
                v4.tabBarItem = ESTabBarItem.init(title: Bundle.main.localizedString(forKey: "prods", value: nil, table: "Default"), image: UIImage(named: "Product_Menu-Icon"), selectedImage: UIImage(named: "Product_Menu-Icon"))
                v5.tabBarItem = ESTabBarItem.init(title: Bundle.main.localizedString(forKey: "myaccount", value: nil, table: "Default"), image: UIImage(named: "Myaccount-Icon"), selectedImage: UIImage(named: "Myaccount-Icon"))
                
                esTabController.tabBar.tintColor = UIColor.white
                
                
                esTabController.viewControllers = [mainViewController,v2,v3,v4,v5]
                esTabController.selectedIndex = 0
                
                esTabController.tabBar.items?[0].setTitleTextAttributes([NSForegroundColorAttributeName: hexStringToUIColor(hex: "#FFFFFF")], for:.normal)
                
                
                esTabController.tabBar.items?[0].setTitleTextAttributes([NSForegroundColorAttributeName: hexStringToUIColor(hex: "#D9B878")], for:.selected)
                
                UITabBar.appearance().barTintColor = UIColor.black // your color
                UITabBar.appearance().isOpaque = true
                UITabBar.appearance().isTranslucent = false
                
                let navigationController = UINavigationController.init(rootViewController: esTabController)
                navigationController.navigationBar.isHidden = true
                navigationController.setNavigationBarHidden(true, animated: false)
                
                self.window?.rootViewController = navigationController
                
                
            }
            self.window?.makeKeyAndVisible()
            
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

