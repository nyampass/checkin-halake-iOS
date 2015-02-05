//
//  HaLakeAPI.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/05.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class HaLakeAPI: NSObject {
    class func setHeader() {
        var headers: [NSObject : AnyObject] = ["X-HaLake-Key": Settings.APIHeadersKey]
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
    }
    
    struct Props {
        static let defaultConnectErrorMessage = "接続に失敗しました。接続環境を確認の上再度お試し下さい"
    }
    
    class func login(email: String, password: String, callback: (userData: AnyObject?, alertMessage: String!) -> ()) {
        var params = [
            "email": email,
            "password": password
        ]
        
        setHeader()
        request(.POST, Settings.APIBaseURL + "/login", parameters: params)
            .responseJSON {(request, response, data, error) in
                var alertMessage: String?,
                    isSuccess: Bool = false,
                    userData: AnyObject?

                if((error) != nil) {
                    alertMessage = Props.defaultConnectErrorMessage
                } else {
                    println(response)
                    println(data)
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        isSuccess = (success == "success")
                        
                        if isSuccess {
                            userData = json["user"]
                        } else {
                            alertMessage = json["reason"] as? String
                        }
                    } else {
                        alertMessage = "認証に失敗しました"
                    }
                }

                callback(userData: userData, alertMessage: alertMessage)
        }
    }
}
