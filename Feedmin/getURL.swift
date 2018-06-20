//
//  getRssURL.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/06.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*
 ・トップページのURLでない場合、トップページのURLに戻った上で、rssデータを取得する.
 ・様々なサイトのrssデータを取得できるようにする。
 http://rssblog.ameba.jp/［アメーバID］/rss.html
 ・rss情報がなかった場合の処理
 
 */
//----------------------------------------------

//サイトタイトルとサイトURLを保存.
var siteURLList:[String?] = []
var siteTitleList:[String?] = []


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
        return siteInfoList.count
    }
    
    
    //セルの内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "urlCell",for:indexPath) as! UITableViewCell

        
        cell.textLabel?.text = siteInfoList[indexPath.row]?.siteTitle
        cell.detailTextLabel?.text = siteInfoList[indexPath.row]?.siteURL
        return cell
    }
    //セルを横にスライドさせた時に呼ばれる
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        print("サイトを削除します")
        
        if siteInfoList.count > 1{
            //削除したURLの記事情報を削除
            deleteArticleInfo(siteID: indexPath.row)
            deleteSiteInfo(Index: indexPath.row)
            
            //tableから削除
            siteInfoList.remove(at: indexPath.row)
            
            //index.rowより大きいIDを1減らす。
            for i in indexPath.row + 1..<siteInfoList.count+1{
                updateSiteInfo(siteID: i)
                updateArticleInfo(siteID: i)
            }
            getURLTableView.reloadData()
            //再読み込みの必要ありManyViewPage
            let mVC1 = tabBarController?.customizableViewControllers![0] as! manyViewControllers
            mVC1.initPageMenu()
            
            
        }else{
            let alert = UIAlertController(title: "エラー", message: "登録しているサイトが1つの場合、削除できません。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in print("OK")}))
            alert.view.layer.cornerRadius = 25 //角丸にする。
            present(alert,animated: true,completion: {()->Void in print("URL削除時のエラー")})
        }
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
            
            var siteID = siteInfoList.count
            var siteTitle = alert.textFields![0].text!
            var siteURL = alert.textFields![1].text!
            
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
            //print(siteURL)
//-----------------------------------------------
//CoreData
            
            writeSiteInfo(siteID: siteID,siteTitle: siteTitle,siteURL: siteURL)
            siteInfoList = readSiteInfo()
            
            
//-----------------------------------------------
            
            

            //タブの0番目
            let mVC2 = tabBarController?.customizableViewControllers![0] as! manyViewControllers
                mVC2.addPage(siteTitle: siteTitle)
            
            print("リロード完了")
            
            getURLTableView.reloadData()
            
        }
        
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
