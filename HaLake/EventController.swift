//
//  EventController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/18.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class EventController: UITableViewController {
    override init() {
        super.init()

        self.tabBarItem.image = UIImage(named:"tabbar_news.png")
        self.tabBarItem.title = "イベント"
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIUtils.setNavigationBar(self, title: self.tabBarItem.title!)
        
        var nib  = UINib(nibName: "EventCell", bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "EventCell")

        addRow()
        addRow()
        addRow()
        addRow()

    }

    
    let kCellIdentifier = "EventCell"
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func contentSizeCategoryChanged(notification: NSNotification)
    {
        tableView.reloadData()
    }
    
    // Deletes all rows in the table view and replaces the model with a new empty one
    
    func addRow()
    {
        addSingleItem()
        
        let lastIndexPath = NSIndexPath(forRow: dataArray.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: .Automatic)
    }
    
    var dataArray: Array<(title:String, body:String)> = Array()
    func addSingleItem()
    {
        var fontFamilies = UIFont.familyNames()
        
        let r = random() % fontFamilies.count
        let familyName: AnyObject = fontFamilies[r]
        
        if let familyNameString: String = familyName as? String {
            dataArray.append((title: familyNameString, body: randomLoremIpsum()))
        }
    }
    
    
    func randomLoremIpsum() -> String
    {
        let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales. Vestibulum ut est id mauris ultrices gravida. Nulla malesuada metus ut erat malesuada, vitae ornare neque semper. Aenean a commodo justo, vel placerat odio. Curabitur vitae consequat tortor. Aenean eu magna ante. Integer tristique elit ac augue laoreet, eget pulvinar lacus dictum. Cras eleifend lacus eget pharetra elementum. Etiam fermentum eu felis eu tristique. Integer eu purus vitae turpis blandit consectetur. Nulla facilisi. Praesent bibendum massa eu metus pulvinar, quis tristique nunc commodo. Ut varius aliquam elit, a tincidunt elit aliquam non. Nunc ac leo purus. Proin condimentum placerat ligula, at tristique neque scelerisque ut. Suspendisse ut congue enim. Integer id sem nisl. Nam dignissim, lectus et dictum sollicitudin, libero augue ullamcorper justo, nec consectetur dolor arcu sed justo. Proin rutrum pharetra lectus, vel gravida ante venenatis sed. Mauris lacinia urna vehicula felis aliquet venenatis. Suspendisse non pretium sapien. Proin id dolor ultricies, dictum augue non, euismod ante. Vivamus et luctus augue, a luctus mi. Maecenas sit amet felis in magna vestibulum viverra vel ut est. Suspendisse potenti. Morbi nec odio pretium lacus laoreet volutpat sit amet at ipsum. Etiam pretium purus vitae tortor auctor, quis cursus metus vehicula. Integer ultricies facilisis arcu, non congue orci pharetra quis. Vivamus pulvinar ligula neque, et vehicula ipsum euismod quis."
        
        var loremIpsumArray = loremIpsum.componentsSeparatedByString(" ")
        
        let minimumNumberOfWords = 3
        let r = max(minimumNumberOfWords, random() % loremIpsumArray.count) // get a random number r, where:  minimumNumberOfWords <= r <= loremIpsumArray.count
        let loremIpsumRandom = loremIpsumArray[0..<r] // grab a slice of the lorem ipsum array that contains r number of words
        
        let loremIpsumText = loremIpsumRandom.reduce("") { "\($0) \($1)" } // join the array of words to make a string
        return "\(loremIpsumText)!!!" // append "!!!" so that we always know what the ending characters are
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? EventCell {
            let modelItem = dataArray[indexPath.row]
            cell.titleLabel.text = "hogehoge"
            
          //  var newBounds = cell.bounds
          //  newBounds.size.width = tableView.bounds.width
          //  cell.bounds = newBounds
            
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145
    }
}
