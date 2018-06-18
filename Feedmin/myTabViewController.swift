//
//  myTabViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/18.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class myTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ステータスバーの背景色変更.UIViewを作成し追加することで実現
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBar.backgroundColor = UIColor(red: 0, green: 0.02, blue: 0.06, alpha: 1.0)
        view.addSubview(statusBar)

        //アイコン色
        UITabBar.appearance().tintColor = .white
        
        //背景色
        UITabBar.appearance().barTintColor = UIColor(red: 0, green: 0.02, blue: 0.06, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
