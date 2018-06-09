//
//  favTableViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/09.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

var favTest = ["こんにちは","ねむいね","おはよー"]

var favItemList:[favItem] = []

class favItem {
    var title = ""
    var URL = ""
    var thumbImage:UIImage!
}




import UIKit


class favTableViewController:UITableViewController{
    
    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //cellContentViewを呼び出し、myTableViewに登録
        let nib = UINib(nibName:"cellContentView",bundle:nil)
        favTableView.register(nib, forCellReuseIdentifier: "favCell")
        
    }

    //行数を決める
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favTest.count
    }

    //セルの内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "favCell",for:indexPath) as! cellContentView
        cell.titleLabel.text = favTest[indexPath.row]
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
