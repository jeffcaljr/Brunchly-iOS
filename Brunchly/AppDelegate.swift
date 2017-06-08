//
//  AppDelegate.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
//    var top: UIViewController? {
//        get {
//            return topViewController()
//        }
//    }
//    
//    var root: UIViewController? {
//        get {
//            return UIApplication.shared.delegate?.window??.rootViewController
//        }
//    }
    
//    func topViewController(from viewController: UIViewController? = root) -> UIViewController? {
//        if let tabBarViewController = viewController as? UITabBarController {
//            return topViewController(from: tabBarViewController.selectedViewController)
//        } else if let navigationController = viewController as? UINavigationController {
//            return topViewController(from: navigationController.visibleViewController)
//        } else if let presentedViewController = viewController?.presentedViewController {
//            return topViewController(from: presentedViewController)
//        } else {
//            return viewController
//        }
//    }
    
    var navigationMenu: UINavigationController?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var isAuthenticated: Bool = false
        
        if FBSDKAccessToken.current() != nil {
            if FIRAuth.auth()?.currentUser != nil{
                isAuthenticated = true
            }
        }
        
        let storyboard = self.window?.rootViewController?.storyboard
        if isAuthenticated {
            GlobalUser.sharedInstance.getUserRemote(callback: { (user) in
                if let user = user{
                    if let isProfileComplete = user.isProfileComplete, isProfileComplete == true{
                        //set root vc to home screen
                        self.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "HomeScreen")
                    }
                    else{
                        //set root view to profile screen
                        self.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileScreen")
                    }
                }
            })
        }
        else{
            //set root view to welcome screen
            self.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen")
        }
        
        navigationMenu = storyboard?.instantiateViewController(withIdentifier: "NavigationMenuController") as! UINavigationController
        
        //TODO: TEST CODE: DELETE LATER!
        MockUserService.shared.loadUsers(count: 25, gender: TestGender.female, withCompletion:
            { (users, images) in
        })
        

        return true
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
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }
    
    
    func logout(){
        try? FIRAuth.auth()?.signOut()
        FBSDKLoginManager().logOut()
        
        let rootVC = self.window?.rootViewController
        
        let newRoot = rootVC?.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeViewController
        self.window?.rootViewController = newRoot
        
        navigationMenu = nil
//        rootVC?.dismiss(animated: true, completion: nil)
        
//        let childViewControllers = rootVC?.childViewControllers
//        if let children = childViewControllers{
//            for childVC in children{
//                print("childVC: \(childVC.description)")
//                childVC.dismiss(animated: true, completion: nil)
//            }
//        }
        
//        if let thisRoot = rootVC as? WelcomeViewController{
//            //rootvc is a welcome view controller
//        }
//        else{
//            //rootvc was not a welcome view controller
//            let newRoot = rootVC?.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeViewController
//            self.window?.rootViewController = newRoot
//            rootVC?.dismiss(animated: false, completion: nil)
//        }
        
    }
    
    func openNavigationMenu(){
        if navigationMenu == nil{
            let storyboard = self.window?.rootViewController?.storyboard
            navigationMenu = storyboard?.instantiateViewController(withIdentifier: "NavigationMenuController") as! UINavigationController
            
        }
        
        if !navigationMenu!.isBeingPresented{
            
            if var topController = self.window?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                // topController should now be your topmost view controller
                topController.present(navigationMenu!, animated: true, completion: nil)
            }
            
            
        }
    }
    


}

