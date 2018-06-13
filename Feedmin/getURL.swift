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
 
 
 
 ・CoreDataに保存したいこと
    登録したサイトのURL
    登録したサイトのタイトル
    登録したサイトの記事情報
        記事タイトル
        画像データ
        記事URL
        お気に入りかどうか
 */
//----------------------------------------------
var siteURLList:[String?] = ["https://togamin.com/feed/"]
var siteTitleList:[String?] = ["とがみんブログ"]
/*
var siteURLList = ["http://togamin.com/feed/","http://www.mikytechblog.com/rss","http://sodekoo.com/feed/","https://haxpig.com/feed","http://diamondxitiao.site/feed"]

var siteTitleList = ["とがみんブログ","マイク","そでこ","れおさん","ダイヤ"]
*/


//後で、favTitleList、favImageList、favLinkListをまとめる必要あり。
var favTitleList:[String]! = []
var favImageList:[UIImage]! = []
var favLinkList:[String]! = []
var favMainTitleList:[String]! = []

var favItemList:[favItem] = []

class favItem {
    var title = ""
    var URL = ""
    var thumbImage:UIImage!
}


//----------------------------------------------




import UIKit
import CoreData

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
    //セルを横にスライドさせた時に呼ばれる
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("スライドしたよね?")
        print(indexPath.row)
        deleteSiteInfo(Index: indexPath.row)
        siteTitleList.remove(at: indexPath.row)
        siteURLList.remove(at: indexPath.row)
        getURLTableView.reloadData()
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
            
            
            print("サイト情報：\(titleText):\(urlText)")
            
/*-----------------------------------------------#
ここで得たURLの処理をする。
* WordPress
http://togamin.com/feed/
http://togamin.com/rss/
* はてなブログ
http://why-not-1017.hatenablog.com/rss
* アメーバブログ
http://feedblog.ameba.jp/rss/ameblo/oranger13

#-----------------------------------------------*/
//CoreData
            
            writeSiteInfo(titleText: titleText,urlText: urlText)
            
            
//-----------------------------------------------
            

            
            
            siteTitleList.append(titleText)
            siteURLList.append(urlText)
        
            
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
