//
//  AppDelegate.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2014/12/25.
//  Copyright (c) 2014年 Nyampass Corporation. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var region: CLBeaconRegion?
    var manager: CLLocationManager?
    let proximityUUID = NSUUID(UUIDString:"00000000-4590-1001-B000-001C4D92F266")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let colorBg = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        UITabBar.appearance().barTintColor = colorBg

        setupIBeacon()
        
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            let settings = UIUserNotificationSettings(forTypes:
                    UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        if (Store.account()? == nil) {
            window?.rootViewController = StartupController()
        } else {
            window?.rootViewController = self.mainController()
        }
        window?.makeKeyAndVisible()

        return true
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager?.requestStateForRegion(self.region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        self.sendLocalNotificationForMessage("Enter Region")
        
        if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
            self.manager?.startRangingBeaconsInRegion(region as CLBeaconRegion)
        }
    }

    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        self.sendLocalNotificationForMessage("Enter Region")
        
        if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
            let reg = region as CLBeaconRegion
            self.manager?.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        }
    }
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        switch(state) {
        case .Inside:
            if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
                let reg = region as CLBeaconRegion
                self.manager?.startRangingBeaconsInRegion(reg)
            }
            break
        case .Outside:
            break
        case .Unknown:
            break
        default:
            break
        }
    }
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if(beacons.count > 0) {
            let nearestBeacon = beacons[0] as? CLBeacon
            
            var proximity:CLProximity! = nearestBeacon?.proximity
            var bAccuracy:CLLocationAccuracy! = nearestBeacon?.accuracy
            var rangeMessage:NSString
            
            if(proximity == CLProximity.Immediate) {
                rangeMessage = "Range Immediate"
            } else if(proximity == CLProximity.Near) {
                rangeMessage = "Range Near"
            } else if(proximity == CLProximity.Far) {
                rangeMessage = "Range Far"
            } else if(proximity == CLProximity.Unknown) {
                rangeMessage = "Range Unknown"
            }
            
            let str = "\(bAccuracy) [m]"
            self.sendLocalNotificationForMessage(str)
        }
    }
    
    func sendLocalNotificationForMessage(message: NSString!) {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = message
        localNotification.fireDate = NSDate()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func setupIBeacon()
    {
        region = CLBeaconRegion(proximityUUID:proximityUUID,identifier:"iBeacon")
        manager = CLLocationManager()
        manager?.delegate = self
    
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            self.manager?.startRangingBeaconsInRegion(self.region)

        case .NotDetermined:
            
            if(NSProcessInfo().operatingSystemVersion.majorVersion >= 8) {
                self.manager?.requestAlwaysAuthorization()
            }else{
                self.manager?.startRangingBeaconsInRegion(self.region)
            }
        // case .Restricted, .Denied:
        default:
            println("do nothing")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == .NotDetermined) {
        } else if(status == .Authorized) {
            self.manager?.startMonitoringForRegion(self.region)
        } else if(status == .AuthorizedWhenInUse) {
            self.manager?.startRangingBeaconsInRegion(self.region)
        }
    }
    
    func mainController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let tabs = NSArray(objects: UIUtils.navigation(TicketController()),
            UIUtils.navigation(EventController()),
            UIUtils.navigation(AccountController()))
        tabBarController.setViewControllers(tabs, animated: false)

        return tabBarController
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

