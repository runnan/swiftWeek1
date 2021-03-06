//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Khang Le on 7/5/16.
//  Copyright © 2016 Khang Le. All rights reserved.
//

import UIKit
import FontAwesome_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    
       window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyBoard.instantiateViewControllerWithIdentifier("movieNavigationController") as! UINavigationController
        
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MovieController
        nowPlayingViewController.endPoint = "now_playing"
        nowPlayingViewController.tabBarItem.title = "Now Playing"
        nowPlayingViewController.tabBarItem.image = UIImage.fontAwesomeIconWithName(.Film, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
        let topRatedNavigationController = storyBoard.instantiateViewControllerWithIdentifier("movieNavigationController") as! UINavigationController
        
        let topRatedViewController = topRatedNavigationController.topViewController as! MovieController
        topRatedViewController.endPoint = "top_rated"
        topRatedViewController.tabBarItem.title = "Top Rated"
        topRatedViewController.tabBarItem.image = UIImage.fontAwesomeIconWithName(.Star, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [nowPlayingViewController, topRatedViewController]
        
        //Need create navigationController to pass value to detail controller
        let navigationController = UINavigationController()
        navigationController.viewControllers = [tabBarController]
        
        navigationController.navigationBar.setBackgroundImage(UIImage(named: "codepath-logo"), forBarMetrics: .Default)
        navigationController.navigationBar.tintColor = UIColor.blackColor()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
 
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

