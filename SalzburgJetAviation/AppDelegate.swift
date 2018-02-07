//
//  AppDelegate.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import OneSignal
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver {

    var window: UIWindow?

    var launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    var notificationReceivedBlock: OSHandleNotificationReceivedBlock?
    var notificationOpenedBlock: OSHandleNotificationActionBlock?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        
        ReachabilityManager.setup()
        
        self.launchOptions = launchOptions
        self.setupOneSignal(launchOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navController = UINavigationController(rootViewController: HomeController())
        
        window?.rootViewController = navController
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = StyleGuideManager.mainBackgroundColor
        
        UITabBar.appearance().backgroundImage = UIImage.colored(.clear)
        UITabBar.appearance().shadowImage = UIImage.colored(UIColor.gray)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("the app enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("the app is active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("the app enter terminates")
    }


}

//MARK: setup onesignal

extension AppDelegate {
    fileprivate func setupOneSignal(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        notificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
            
            let state: UIApplicationState = UIApplication.shared.applicationState
            if state == UIApplicationState.background {
                
            } else if state == UIApplicationState.active {
                
            }
            
            
        }
        
        notificationOpenedBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body)")
            print("badge number = \(payload?.badge)")
            print("notification sound = \(payload?.sound!)")
            
            let state: UIApplicationState = UIApplication.shared.applicationState
            if state == UIApplicationState.background {
                
                if let additionalData = result!.notification.payload!.additionalData {
                    
                }
            } else if state == UIApplicationState.active {
                
            } else if state == UIApplicationState.inactive {
                
            }
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)")
                
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    
                    print("actionID = \(actionID)")
                    
                    if actionID == "id2" {
                        print("do something when button 2 is pressed")
                        
                        
                    } else if actionID == "id1" {
                        print("do something when button 1 is pressed")
                        
                    }
                }
            }
        }
        
        
        self.setupOnesignalObserver()
        
//        let nc = NotificationCenter.default
//        nc.addObserver(self, selector: #selector(self.setupOnesignalObserver), name: .SetupOneSignal, object: nil)
    }
    
    @objc fileprivate func setupOnesignalObserver() {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "90912c11-ad1c-49eb-9773-15b21703e4ec", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let hasPrompted = status.permissionStatus.hasPrompted
        if hasPrompted == false {
            // Call when you want to prompt the user to accept push notifications.
            // Only call once and only if you set kOSSettingsKeyAutoPrompt in AppDelegate to false.
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                if accepted == true {
                    print("User accepted notifications: \(accepted)")
                } else {
                    print("User accepted notificationsfalse: \(accepted)")
                }
            })
        } else {
        }
        
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
}

