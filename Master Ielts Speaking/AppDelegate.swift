//
//  AppDelegate.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // navigation bar red
        UINavigationBar.appearance().backgroundColor = UIColor.red
        // make the color of status bar to white
        UINavigationBar.appearance().barStyle = UIBarStyle.blackTranslucent
        ifFirstLaunchSaveToDatabaseFromFile()
        
        /*
        let config = Realm.Configuration(

            schemaVersion: 1,

            migrationBlock: { migration, oldSchemaVersion in
                
                if oldSchemaVersion < 1 {

                }
        }
        )
        Realm.Configuration.defaultConfiguration = config
 */
        
        return true
    }
    
    /// Check if it is the first time which user launch the application, it would read from json files and save it inside database
    fileprivate func ifFirstLaunchSaveToDatabaseFromFile() {
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        var hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if hasLaunched ==  false {
            MockData.saveCategories()
            MockData.saveWords(nameOfCategory: CategoryName.friends)
            MockData.saveWords(nameOfCategory: CategoryName.Environment)
            MockData.saveWords(nameOfCategory: CategoryName.Book)
            MockData.saveWords(nameOfCategory: CategoryName.HomeTown)
            MockData.saveWords(nameOfCategory: CategoryName.Family)
        }
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

