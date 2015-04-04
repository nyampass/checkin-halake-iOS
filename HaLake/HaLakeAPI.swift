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
    
    class func login(email: String, password: String, callback: (userData: Dictionary<String, AnyObject>?, alertMessage: String!) -> ()) {
        var params = [
            "email": email,
            "password": password
        ]
        
        setHeader()
        request(.POST, Settings.APIBaseURL + "/login", parameters: params)
            .responseJSON {(request, response, data, error) in
                var alertMessage: String?,
                    isSuccess: Bool = false,
                    userData: Dictionary<String, AnyObject>?
                
                if((error) != nil) {
                    alertMessage = Props.defaultConnectErrorMessage

                } else {
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        isSuccess = (success == "success")
                        
                        if isSuccess {
                            if let userJson: Dictionary<String, AnyObject> = json["user"] as? Dictionary<String, AnyObject> {
                                userData = userJson
                            }
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
    
    class func useTicket(ticketType: String, callback: (isSuccess: Bool) -> ()) {
        let (email, password) = User.authentication()
        
        request(.PUT, Settings.APIBaseURL + "/users/me/tickets/" + ticketType, parameters: [
            "email": email!,
            "password": password!,
            "used": true
            ]).responseJSON {(request, response, data, error) in
                println(request)
                println(response)
                if((error) == nil) {
                    print(data)
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        let isSuccess = (success == "success")

                        if isSuccess {
                            callback(isSuccess: true)
                            return
                        }
                    }
                }

                callback(isSuccess: false)
        }
    }

    class func checkin(callback: (isSuccess: Bool) -> ()) {
        changeCheckinStatus(true, callback: callback)
    }
    
    class func checkout(callback: (isSuccess: Bool) -> ()) {
        changeCheckinStatus(false, callback: callback)
    }
    
    class func changeCheckinStatus(isCheckin: Bool, callback: (isSuccess: Bool) -> ()) {
        let (email, password) = User.authentication()
        let url = Settings.APIBaseURL + (isCheckin ? "/checkin": "/checkout")

        request(.POST, url, parameters: [
            "email": email!,
            "password": password!,
            ]).responseJSON {(request, response, data, error) in
                if((error) == nil) {
                    print(data)
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        let isSuccess = (success == "success")
                        
                        if isSuccess {
                            callback(isSuccess: true)
                            return
                        }
                    }
                }
                
                callback(isSuccess: false)
        }
    }

    class func events(callback: (eventsData: Array<Event>?) -> ()) {
        let (email, password) = User.authentication()

        request(.GET, Settings.APIBaseURL + "/events", parameters: [
            "email": email!,
            "password": password!
            ]).responseJSON {(request, response, data, error) in
                if((error) == nil) {
                    print(data)
                    if let json = data as? NSDictionary {
                        let success = json["status"] as? String
                        let isSuccess = (success == "success")
                        
                        if isSuccess {
                            var events: [Event] = []
                            if let jsonEvents = json["events"] as? Array<Dictionary<String, AnyObject>> {
                                for dic: Dictionary<String, AnyObject> in jsonEvents {
                                    if let event = Event.dic2event(dic) {
                                        events.append(event)
                                    }
                                }
                            }
                            callback(eventsData: events)
                            return
                        }
                    }
                }
                
                callback(eventsData: nil)
        }
    }
    
    class func pushDeviceToken(token: String) {
        let (email, password) = User.authentication()
        
        if (email) != nil && (password) != nil {
            request(.PUT, Settings.APIBaseURL + "/users/me/tokens", parameters: [
                "email": email!,
                "password": password!,
                "key": "apns",
                "value": token
                ]).responseJSON {(request, response, data, error) in
            }
        }
    }
}
