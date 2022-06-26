//
//  AppDelegate.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2021/11/2.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController.init(rootViewController: ViewController.init())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

