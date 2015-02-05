//
//  CreateAccountController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/05.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class CreateAccountController: UITableViewController {
    var nameField: UITextField?, emailField: UITextField?,
        passwordFied: UITextField?,
        confirmPasswordField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIUtils.setNavigationBar(self, title: "ユーザ登録")

        UIBarButtonItem.configureFlatButtonsWithColor(UIColor.pumpkinColor(),
            highlightedColor: UIColor.carrotColor(), cornerRadius: 2)
        
        self.navigationItem.leftBarButtonItem = UIUtils.barButtonItem("閉じる", target: self, action: "tapCancel:")
        self.navigationItem.rightBarButtonItem = UIUtils.barButtonItem("作成", target: self, action: "tapCreate:")
        
        let nib = UINib(nibName: "InputCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "InputCell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tapCancel(barButtonItem: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tapCreate(barButtonItem: UIBarButtonItem)
    {
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
                            let id = json["user"]?["_id"]? as String
                            User.saveAuthentication(id, password: params["password"]!)
                            
                            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
                            delegate.window?.rootViewController = delegate.mainController()
                            return
                        }
                        alertMessage = json["reason"] as? String
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    UIUtils.hideActivityIndicator(self.view)
                    
                    let alert = UIAlertView()
                    alert.message = alertMessage
                    alert.addButtonWithTitle("Understod")
                    alert.show()
                })
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as UITableViewCell
        if let inputCell = cell as? InputCell {
            inputCell.textField.keyboardType = UIKeyboardType.EmailAddress
            inputCell.textField.returnKeyType = UIReturnKeyType.Next
            
            inputCell.textField.placeholder = "Required";
            //playerTextField.keyboardType = UIKeyboardTypeDefault;
            //playerTextField.returnKeyType = UIReturnKeyDone;
            //playerTextField.secureTextEntry = YES;
            
            var label: String = "", isSecure: Bool = false

            switch (indexPath.row) {
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
        }
        
        return cell
    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
