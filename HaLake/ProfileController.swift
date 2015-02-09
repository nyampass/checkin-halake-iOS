//
//  ProfileController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/28.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var sections: Array<(title: String, rows: Array<(id: String, title: String, value: String)>)>!

    @IBOutlet weak var profileTableView: UITableView!

    override init() {
        super.init()
        
        self.tabBarItem.image = UIImage(named:"tabbar_me.png")
        self.tabBarItem.title = "プロフィール"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "ProfileController", bundle: nil)
    }
    
    func setUser(user: User ) {
        self.user = user
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = Array()
        
        sections.append(title: "",
            rows: [(id: "name", title: "名前", value: user!.name),
                (id: "email", title: "メールアドレス", value: user!.id),
            ])
        
        sections.append(title: "連絡先",
            rows: [(id: "tel", title: "Tel", value: user?.phone ?? "")])

        sections.append(title: "",
            rows: [(id: "logout", title: "", value: "")])

        self.navigationController?.navigationBarHidden = true
        
        profileTableView.registerClass(TitleAndSubTitleCell.self,
            forCellReuseIdentifier: "default")
        profileTableView.registerNib(UINib(nibName: "ButtonCell", bundle: nil),
            forCellReuseIdentifier: "button")

        profileTableView.delegate = self
        profileTableView.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].rows.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row  = sections[indexPath.section].rows[indexPath.row]

        if row.id == "logout" {
            if let cell: ButtonCell = tableView.dequeueReusableCellWithIdentifier("button")
                    as? ButtonCell {
            
                cell.button .addTarget(self, action: "tapLogout",
                    forControlEvents: .TouchUpInside)
            
                return cell
            }
        }
        
        
        if let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("default") as? UITableViewCell {
            let rows  = sections[indexPath.section].rows
            
            cell.tag = indexPath.section

            cell.textLabel?.text = rows[indexPath.row].title
            cell.textLabel?.textColor = UIColor.asbestosColor()

            cell.detailTextLabel?.text = rows[indexPath.row].value
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tapLogout() {
        User.saveAuthentication("", password: "")
        (UIApplication.sharedApplication().delegate as AppDelegate).window?.rootViewController =
                StartupController()

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
