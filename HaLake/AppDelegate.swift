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
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, FUIAlertViewDelegate {
    var window: UIWindow?

    var region: CLBeaconRegion?
    var manager: CLLocationManager?
    let proximityUUID = NSUUID(UUIDString:"00000000-4590-1001-B000-001C4D92F266")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let colorBg = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        UITabBar.appearance().barTintColor = colorBg

        setupIBeacon()

        let types = UIRemoteNotificationType.Alert |
                UIRemoteNotificationType.Badge |
                UIRemoteNotificationType.Sound
        application.registerForRemoteNotifications()
        application.registerForRemoteNotificationTypes(types)
        
        let (id, password) = User.authentication()
        if (id == nil) {
            window?.rootViewController = StartupController()
        } else {
            window?.rootViewController = mainController()
            
        }
        window?.makeKeyAndVisible()
        return true
    }

    var latestCheckin: NSDate!
    let waitLatestCheckinInterval = 60.0 // sec
    var isShowingAlert = false
    
    let alertViewTagCheckin = 1,
        alertViewTagConfirmCheckout = 2
    
    func checkin()
    {
        if !User.isValidAuthentication() {
            return
        }
        
        if isShowingAlert {
            return
        }
        
        if (latestCheckin == nil ||
                latestCheckin!.timeIntervalSinceNow < -waitLatestCheckinInterval) {
            latestCheckin = NSDate()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let isAlreadyCheckin = User.isTodaysCheckin()
                
                if (!isAlreadyCheckin) {
                    let alertView = UIUtils.alertView(nil,
                        message: "HaLakeにチェックインしました！\nありがとうございます！",
                        delegate: self, cancelButtonTitle: "OK")
                    alertView.tag = self.alertViewTagCheckin
                    
                    self.isShowingAlert = true
                    
                    alertView.show()
                    
                    User.checkin()

                } else {
                    let alertView = UIUtils.alertView(nil,
                        message: "HaLakeからチェックアウトしますか？",
                        delegate: self, cancelButtonTitle: "キャンセル")
                    UIUtils.addButtonToAlertView(alertView, title: "チェックアウト")
                    alertView.tag = self.alertViewTagConfirmCheckout

                    self.isShowingAlert = true

                    alertView.show()
                }
            })
        }
    }
    
    func alertView(alertView: FUIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        isShowingAlert = false
        if alertView.tag == alertViewTagConfirmCheckout &&
                buttonIndex == 1{
            User.checkout()
        }
    }

    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager?.requestStateForRegion(self.region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
            self.manager?.startRangingBeaconsInRegion(region as CLBeaconRegion)
        }
    }

    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
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
        default:
            break
        }
    }

    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if(beacons.count > 0) {
            let beacon = beacons[0] as? CLBeacon
            let proximity:CLProximity! = beacon?.proximity
            
            if( beacon?.major == 8019 && beacon?.major == 8019 &&
                proximity == CLProximity.Immediate) {
                self.checkin()
            }
        }
    }
    
    func setupIBeacon() {
        region = CLBeaconRegion(proximityUUID:proximityUUID,identifier:"HaLakeBeacon")
        region?.notifyOnEntry = false
        region?.notifyOnExit = false
        region?.notifyEntryStateOnDisplay = true
        
        manager = CLLocationManager()
        manager?.delegate = self
    
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            self.manager?.startRangingBeaconsInRegion(self.region)

        case .NotDetermined:
            if (NSProcessInfo().respondsToSelector("operatingSystemVersion") &&
                    NSProcessInfo().operatingSystemVersion.majorVersion >= 8) {
                self.manager?.requestWhenInUseAuthorization()
            }else{
                self.manager?.startRangingBeaconsInRegion(self.region)
            }
        default:
            break
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
        let tabs = NSArray(objects: UIUtils.navigation(TicketController()),
            UIUtils.navigation(EventController()),
            UIUtils.navigation(ProfileController()))

        let tabBarController = TabBarController()
        tabBarController.setViewControllers(tabs, animated: false)
        tabBarController.selectedIndex = 1

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

