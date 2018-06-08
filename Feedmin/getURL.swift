//
//  getRssURL.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/06.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*
 URLの登録をすると、配列にrssのURLが入れ込まれる。登録したら、rssデータを読み込み、ページメニューに表示する。
 ・トップページのURLでない場合、トップページのURLに戻った上で、rssデータを取得する.
 ・様々なサイトのrssデータを取得できるようにする。
 http://rssblog.ameba.jp/［アメーバID］/rss.html
 ・rss情報がなかった場合の処理
 
 
 
 ・出力データ
    siteURLList
    siteTitle
 
 */
import UIKit

class getURL:UITableViewController{
    
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell",for:indexPath) as! UITableViewCell
        return cell
    }
    
    
    
    
    //クリックするとアラート表示.タイトルとURLを入力する画面を表示.入力後、RSS用URLに変換し、タイトルとURLの配列に代入する。そして、Viewのセルにタイトルの一覧を表示する。
    @IBAction func addURL(_ sender: UIBarButtonItem) {
        
        //alertを作る
        let alertController = UIAlertController(title: "サイトURLの登録 ", message: "登録したいサイトのタイトルとURLを入力してください。", preferredStyle: .alert)
        
        
        func hyouzi(){
            print ("URL登録処理を行います")
        }
        
        print("Alert")
        alertController.addAction(UIAlertAction(title: "登録", style: .default, handler: {action in hyouzi()}))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("キャンセル")}))
        
        //その他アラートオプション
        //alertController.view.backgroundColor = UIColor.cyan//背景色
        alertController.view.layer.cornerRadius = 25 //角丸にする。
        
        present(alertController,animated: true,completion: {()->Void in print("表示されたよん")})//completionは動作完了時に発動。
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
}
