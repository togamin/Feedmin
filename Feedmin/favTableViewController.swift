//
//  favTableViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/09.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit


class favTableViewController:UITableViewController{
    
    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //行数を決める
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    //セルの内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "fabCell",for:indexPath)
        cell.textLabel?.text = "aaaaaaaaaaa"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
