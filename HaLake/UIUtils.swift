//
//  UIUtils.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation

class UIUtils {
    private struct Props {
        static var TAG_INDICATOR_CONTAINER = 2000
        static var TAG_INDICATOR_INDICATOR = 2001
    }
    
    class func barButtonItem(title: String, target: AnyObject?, action: Selector) -> UIBarButtonItem
    {
        let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: target, action: action)

        barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.cloudsColor()],
            forState: UIControlState.Normal)

        return barButtonItem
    }
    
    private class func setAlertViewTheme(alertView: FUIAlertView)
    {
        alertView.titleLabel.textColor = UIColor.cloudsColor()
        alertView.titleLabel.font = UIFont.boldFlatFontOfSize(16.0)
        alertView.messageLabel.textColor = UIColor.cloudsColor()
        alertView.messageLabel.font = UIFont.flatFontOfSize(14.0)
        alertView.backgroundOverlay.backgroundColor = UIColor.cloudsColor().colorWithAlphaComponent(0.8)
        alertView.alertContainer.backgroundColor = UIColor.midnightBlueColor()

        alertView.defaultButtonColor = UIColor.cloudsColor()
        alertView.defaultButtonShadowColor = UIColor.asbestosColor()
        alertView.defaultButtonFont = UIFont.boldFlatFontOfSize(16.0)
        alertView.defaultButtonTitleColor = UIColor.asbestosColor()
    }
    
    class func addButtonToAlertView(alertView: FUIAlertView, title: String) {
        alertView.addButtonWithTitle(title)
        
        let button: FUIButton = alertView.buttons[alertView.buttons.count - 1] as FUIButton
        
        button.buttonColor = UIColor.whiteColor()
        button.shadowColor = alertView.defaultButtonShadowColor
        button.titleLabel?.font = alertView.defaultButtonFont
        button.setTitleColor(UIColor.midnightBlueColor(),
            forState: UIControlState.Normal & UIControlState.Highlighted)
    }
    
    class func alertView(title: String?, message: String?, delegate:FUIAlertViewDelegate?, cancelButtonTitle: String?) -> FUIAlertView {
        let alert = SwiftBridge.createFUIAlertVIew(title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        setAlertViewTheme(alert)

        return alert
    }
    
    class func navigation(controller: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.configureFlatNavigationBarWithColor(UIColor.carrotColor())

        return navigation
    }

    class func setNavigationBar(controller: UIViewController, title: String) {
        let bar = controller.navigationController?.navigationBar
        
        bar?.barTintColor = UIColor.carrotColor()

        let titleLabel = UILabel(frame: CGRectZero)

        titleLabel.textColor = UIColor.cloudsColor()
        titleLabel.text = title
        titleLabel.sizeToFit()
        controller.navigationItem.titleView = titleLabel

        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        backButton.tintColor = UIColor.cloudsColor()
        backButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()],
            forState: UIControlState.Normal)
        controller.navigationItem.backBarButtonItem = backButton
    }

    class func showActivityIndicator(uiView: UIView) {
        let container: UIView = UIView()
        let loadingView: UIView = UIView()
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        container.tag = Props.TAG_INDICATOR_CONTAINER
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.tag = Props.TAG_INDICATOR_INDICATOR
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }

    class func hideActivityIndicator(uiView: UIView) {
        let activityIndicator = uiView.viewWithTag(Props.TAG_INDICATOR_INDICATOR) as? UIActivityIndicatorView
        let container = uiView.viewWithTag(Props.TAG_INDICATOR_CONTAINER)

        activityIndicator?.stopAnimating()
        container?.removeFromSuperview()
    }
    
    class func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func localNotification(message: String) {
        var notif:UILocalNotification = UILocalNotification()

        notif.alertBody = message
        notif.fireDate = NSDate()
        notif.soundName = UILocalNotificationDefaultSoundName

        UIApplication.sharedApplication().scheduleLocalNotification(notif)
    }
}