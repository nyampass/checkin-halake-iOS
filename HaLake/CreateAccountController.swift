//
//  CreateProfileController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/05.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class CreateProfileController: UITableViewController {
    var nameField: UITextField?, emailField: UITextField?,
        passwordFied: UITextField?,
        confirmPasswordField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIUtils.setNavigationBar(self, title: "ユーザ登録")

        UIBarButtonItem.configureFlatButtonsWithColor(UIColor.pumpkinColor(),
            highlightedColor: UIColor.carrotColor(), cornerRadius: 2)
        
        self.navigationItem.leftBarButtonItem = UIUtils.barButtonItem("閉じる", target: self, action: "tapCancel:")

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.registerNib(UINib(nibName: "InputCell", bundle: nil),
            forCellReuseIdentifier: "InputCell")
        
        tableView.registerNib(UINib(nibName: "AgreementInCreateAccountCell", bundle: nil),
            forCellReuseIdentifier: "AgreementCell")

        tableView.registerNib(UINib(nibName: "ButtonCell", bundle: nil),
            forCellReuseIdentifier: "ButtonCell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tapCancel(barButtonItem: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showErrorMessage(message: String) {
        UIUtils.alertView(nil, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func tapCreate(barButtonItem: UIBarButtonItem)
    {
        self.view.endEditing(true)
        var errMessage: String!
        
        if nameField!.text.isEmpty {
            return showErrorMessage("名前を入力して下さい")
        } else if emailField!.text.isEmpty {
            return showErrorMessage("メールアドレスを入力して下さい")
        } else if !DataUtils.isValidEmail(emailField!.text) {
            return showErrorMessage("有効なメールアドレスを入力して下さい")
        } else if passwordFied!.text.isEmpty {
            return showErrorMessage("パスワードを入力して下さい")
        } else if passwordFied!.text != confirmPasswordField!.text {
            return showErrorMessage("パスワードを確認用パスワードと一致させてください")
        }

        UIUtils.showActivityIndicator(self.view)
        
        var params = [
            "email": emailField!.text!,
            "password":passwordFied!.text!,
            "name": nameField!.text!,
        ]
        
        var headers: [NSObject : AnyObject] = ["X-HaLake-Key": Settings.APIHeadersKey]
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        
        request(.POST, Settings.APIBaseURL + "/users", parameters: params)
            .responseJSON {(request, response, data, error) in
                var alertMessage: String? = nil
                if((error) != nil) {
                    alertMessage = "接続に失敗しました。接続環境を確認の上再度お試し下さい"
                } else {
                    var isSuccess: Bool = false
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        isSuccess = (success == "success")
                        
                        if (isSuccess) {
                            UIUtils.hideActivityIndicator(self.view)

                            let id = json["user"]?["_id"]? as String
                            User.saveAuthentication(id, password: params["password"]!)
                            
                            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
                            delegate.window?.rootViewController = delegate.mainController()
                            return
                        }
                        alertMessage = json["reason"] as? String
                        
                        if ((alertMessage) == nil) {
                            alertMessage = "登録に失敗しました。"
                        }
                    }
                }

                dispatch_async(dispatch_get_main_queue(), {
                    UIUtils.hideActivityIndicator(self.view)
                    
                    UIUtils.alertView(nil, message: alertMessage, delegate: nil, cancelButtonTitle: "OK")
                    let alert = UIAlertView()
                    
                    if (alertMessage == nil) {
                        alertMessage = "入力されたアドレスはすでに登録済みです。"
                    }
                    
                    alert.message = alertMessage
                    alert.addButtonWithTitle("OK")

                    alert.show()
                })
        }
    }
    
    func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return 94;
            
        case 5:
            return 44;
            
        default:
            return 44;
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForRowAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForRowAtIndexPath(indexPath)
    }
    
    func tapAgreement() {
        let controller = WebController(url: NSURL(string: Settings.APIBaseURL + "/../agreement.html")!)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AgreementCell", forIndexPath: indexPath) as AgreementInCreateAccountCell
            
            
            cell.agreementButton.addTarget(self, action: "tapAgreement", forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell;

        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as ButtonCell
            
            
            let button = cell.button
            button.setTitle("同意して登録する", forState: .Normal)

            button?.buttonColor = UIColor.sunflowerColor()
            button?.shadowColor = UIColor.orangeColor()
            button?.shadowHeight = 3.0
            button?.cornerRadius = 6.0;
            button?.titleLabel?.font = UIFont.boldFlatFontOfSize(16)
            button?.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Normal)
            button?.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)

            cell.button.addTarget(self, action: "tapCreate:", forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell;
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as UITableViewCell
        if let inputCell = cell as? InputCell {
            inputCell.textField.keyboardType = UIKeyboardType.EmailAddress
            inputCell.textField.returnKeyType = UIReturnKeyType.Next
            
            inputCell.textField.placeholder = "Required";
            //playerTextField.keyboardType = UIKeyboardTypeDefault;
            //playerTextField.returnKeyType = UIReturnKeyDone;
            //playerTextField.secureTextEntry = YES;
            
            var label: String = "", isSecure: Bool = false

            switch (indexPath.row - 1) {
            case 0:
                label = "名前"
                nameField = inputCell.textField
                
            case 1:
                label = "メール"
                emailField = inputCell.textField
                
            case 2:
                label = "パスワード"
                passwordFied = inputCell.textField
                isSecure = true
                
                
            case 3:
                label = "確認用パスワード"
                isSecure = true
                confirmPasswordField = inputCell.textField
                
            default:
                break;
            }

            inputCell.label.text = ""
            inputCell.textField.placeholder = label
            inputCell.textField.secureTextEntry = isSecure
            inputCell.textField.addTarget(self, action: "onDidEndOnExit:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        }
        
        return cell
    }
    
    func onDidEndOnExit(sender: UITextField) {
    
    }
}
