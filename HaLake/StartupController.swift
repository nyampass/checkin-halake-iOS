//
//  StartupController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2014/12/25.
//  Copyright (c) 2014年 Nyampass Corporation. All rights reserved.
//

import UIKit

// import Alamofire

class StartupController: UIViewController, UITextFieldDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: "StartupController", bundle: nil)
    }
    
    override init() {
        super.init(nibName: "StartupController", bundle: nil)
    }

    @IBOutlet weak var button: FUIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var createAccountButton: FUIButton!

    @IBOutlet var createAccountView: UIScrollView!
    
    var loginButton: FUIButton? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton = button as FUIButton
        loginButton?.buttonColor = UIColor.turquoiseColor()
        loginButton?.shadowColor = UIColor.greenSeaColor()
        loginButton?.shadowHeight = 3.0
        loginButton?.cornerRadius = 6.0;
        loginButton?.titleLabel?.font = UIFont.boldFlatFontOfSize(16)
        loginButton?.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Normal)
        loginButton?.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)

        createAccountButton?.buttonColor = UIColor.sunflowerColor()
        createAccountButton?.shadowColor = UIColor.orangeColor()
        createAccountButton?.shadowHeight = 3.0
        createAccountButton?.cornerRadius = 6.0;
        createAccountButton?.titleLabel?.font = UIFont.boldFlatFontOfSize(16)
        createAccountButton?.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Normal)
        createAccountButton?.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)

        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter() .addObserver(self, selector: "onKeyboardWasShown:",
            name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter() .addObserver(self, selector: "onKeyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }

    func onKeyboardWasShown(notif: NSNotification) {
        if let userInfo = notif.userInfo {
            let height = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size.height -
                (self.view.bounds.size.height - self.mainView.frame.size.height - self.mainView.frame.origin.y)
            if height > 0 {
                self.backgroundScrollView.setContentOffset(CGPointMake(0.0, height), animated: true)
            }
        }
        
    }
    
    func onKeyboardWillHide(notif: NSNotification) {
        self.backgroundScrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func tapLogin(sender: AnyObject) {
        UIUtils.showActivityIndicator(self.view)
        
        HaLakeAPI.login(emailTextField.text, password: passwordTextField.text) { (data, alertMessage) -> () in
            dispatch_async(dispatch_get_main_queue(), {
                UIUtils.hideActivityIndicator(self.view)
                
                if (alertMessage != nil) {
                    let alert = UIAlertView()
                    
                    alert.message = alertMessage
                    alert.addButtonWithTitle("OK")
                    
                    alert.show()
                    return;
                }
                User.saveAuthentication(self.emailTextField.text,
                    password: self.passwordTextField.text)

                let delegate = UIApplication.sharedApplication().delegate as AppDelegate
                delegate.window?.rootViewController = delegate.mainController()
            })
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loginButton?.frame = self.button.frame
    }
    
    @IBAction func tapCreateAccount(sender: AnyObject) {
        presentViewController(UIUtils.navigation(CreateAccountController()), animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        loginButton?.frame = self.button.frame
        navigationController?.navigationBarHidden = true
        
        super.viewWillAppear(animated)
    }
}
