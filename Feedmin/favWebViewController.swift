//
//  favWebViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/11.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit
class fabWevViewController:UIViewController{
    
    @IBOutlet weak var favWebView: UIWebView!
    
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link){
            let request = URLRequest(url:url)
            self.favWebView.loadRequest(request)
            //self.ArticleNav.topItem!.title = title
        }
        
    }
}