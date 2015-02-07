//
//  WebController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/07.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class WebController: UIViewController, UIWebViewDelegate {
    var url: NSURL!
    var webView: UIWebView!

    init(url: NSURL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIUtils.setNavigationBar(self, title: "イベント詳細")
        UIBarButtonItem.configureFlatButtonsWithColor(UIColor.pumpkinColor(),
            highlightedColor: UIColor.carrotColor(), cornerRadius: 2)

        self.navigationItem.rightBarButtonItem = UIUtils.barButtonItem("Safari", target: self, action: "tapSafari")
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.webView.delegate = self
        self.webView.loadRequest(NSURLRequest(URL: self.url))

        self.view.addSubview(self.webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapSafari() {
        UIApplication.sharedApplication().openURL(self.url)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true;
    }
}
