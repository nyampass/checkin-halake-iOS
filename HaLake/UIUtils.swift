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

        barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()],
            forState: UIControlState.Normal)

        return barButtonItem
    }
    
    class func setFUIAlertViewTheme(alertView: FUIAlertView)
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
    
    class func navigation(controller: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.configureFlatNavigationBarWithColor(UIColor.orangeColor())

        return navigation
    }

    class func setNavigationBar(controller: UIViewController, title: String) {
        let bar = controller.navigationController?.navigationBar
        
        bar?.barTintColor = UIColor.sunflowerColor()

        let titleLabel = UILabel(frame: CGRectZero)
        // titleLabel.font = UIFont.boldSystemFontOfSize(16.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = title
        titleLabel.sizeToFit()
        controller.navigationItem.titleView = titleLabel
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
}