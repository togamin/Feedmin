//
//  DetailViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/01.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class detailViewController:UIViewController{
    
    @IBOutlet weak var webView: UIWebView!
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link){
            let request = URLRequest(url:url)
            self.webView.loadRequest(request)
        }
    }
}
