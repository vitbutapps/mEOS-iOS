//
//  AppDelegate.swift
//  MEOS
//
//  Created by Виталий on 14/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import MODAppSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dapp = MODapp()
        dapp.name = "MEOS";
        dapp.icon = "https://static.ethte.com/more/images/bigicon.png";
        dapp.version = "1.0";
        dapp.dappDescription = "MEOS is the first full-fledged mobile application for using IOS on Apple devices";
        dapp.uuID = "6e76f5ef-86da-441f-9be8-f7bebef72f9f";
        
        MODAppSDK.register(withDApp: dapp, dappScheme: "MEOSApp", redirectURLString: "https://www.mobileeos.io")
        
        MOSimpleWalletSDK.register(withDApp: dapp)
        
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


}

