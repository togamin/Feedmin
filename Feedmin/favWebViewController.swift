//
//  favWebViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/11.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit
import WebKit

class fabWevViewController:UIViewController{
    
    @IBOutlet weak var favWebKitView: WKWebView!
    
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link){
            let request = URLRequest(url:url)
            self.favWebKitView.load(request)
            //self.ArticleNav.topItem!.title = title
        }
    }
    
    @IBAction func favShare(_ sender: UIBarButtonItem) {
        let controller = UIActivityViewController(activityItems: [URL(string:self.link)], applicationActivities:nil)
        self.present(controller, animated: true,completion:nil)
    }
    
}
