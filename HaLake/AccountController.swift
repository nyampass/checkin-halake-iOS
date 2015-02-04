//
//  AccountController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/28.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class AccountController: UIViewController {
    override init() {
        super.init()
        
        self.tabBarItem.image = UIImage(named:"tabbar_me.png")
        self.tabBarItem.title = "アカウント"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "AccountController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
