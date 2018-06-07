//
//  SettingTableView.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/07.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class SettingViewController:UITableViewController {

    
    @IBOutlet weak var registURL: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    //セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //各セクションのセルの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 「設定」のセクション
            return 1
        case 1: // 「その他」のセクション
            return 3
        case 2: // ここが実行されることはないはず
            return 3
        default:
            return 0
        }
    }
    
 
    
    

    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell",for:indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
        
    }
    //セルをタップしたら発動する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //画面遷移時に呼び出される処理
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){

    }*/

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
    

