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

var siteURLList = ["http://togamin.com/feed/","http://feedblog.ameba.jp/rss/ameblo/oranger13","http://why-not-1017.hatenablog.com/rss"]

var siteTitleList = ["とがみんブログ","宇宙の本質を語る","たか"]

var favTitleList:String?
var favURLList:String?





import UIKit

class getURL:UITableViewController{
    
    @IBOutlet var getURLTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //行数を決める
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteTitleList.count
    }
    
    
    //セルの内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "urlCell",for:indexPath) as! UITableViewCell

        
        cell.textLabel?.text = siteTitleList[indexPath.row]
        cell.detailTextLabel?.text = siteURLList[indexPath.row]
        return cell
    }
    
    
    
    
    //クリックするとアラート表示.タイトルとURLを入力する画面を表示.入力後、RSS用URLに変換し、タイトルとURLの配列に代入する。そして、Viewのセルにタイトルの一覧を表示する。
    @IBAction func addURL(_ sender: UIBarButtonItem) {
        
        //alertを作る
        let alert = UIAlertController(title: "サイトURLの登録 ", message: "登録したいサイトのタイトルとURLを入力してください。", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: {action in getInfo()}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("キャンセル")}))
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(addTitleField: UITextField!) -> Void in
            addTitleField.placeholder = "タイトルを入力してください。"//プレースホルダー
        })
        alert.addTextField(configurationHandler: {(addURLField: UITextField!) -> Void in
            addURLField.placeholder = "URLを入力してください。"//プレースホルダー
        })
        
        //その他アラートオプション
        //alertController.view.backgroundColor = UIColor.cyan//背景色
        alert.view.layer.cornerRadius = 25 //角丸にする。
        
        present(alert,animated: true,completion: {()->Void in print("表示されたよん")})//completionは動作完了時に発動。
        
        
        func getInfo(){
            print ("URL登録処理を行います")
            
            var titleText = alert.textFields![0].text!
            var urlText = alert.textFields![1].text!
            
            
            print("タイトルのリスト：\(titleText):\(urlText)")
            
/*-----------------------------------------------#
得たURLの処理をする。
* WordPress
http://togamin.com/feed/
http://togamin.com/rss/
* はてなブログ
http://why-not-1017.hatenablog.com/rss
* アメーバブログ
http://feedblog.ameba.jp/rss/ameblo/oranger13

#-----------------------------------------------*/
            
            var rssText = urlText + "/rss"
            print("タイトルのリスト：\(titleText):\(rssText)")
            
            
            siteTitleList.append(titleText)
            siteURLList.append(rssText)
        
            
            //上手くいっていない
            manyViewControllers().viewDidLoad()
            print("リロード完了")
            
            
            //print("タイトルのリスト：\(siteTitleList)")
            //print("URLのリスト：\(siteURLList)")
            
            
            
            
            getURLTableView.reloadData()
            
        }
        
        
    }
    

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
}
