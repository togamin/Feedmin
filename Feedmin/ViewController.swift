//
//  ViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/05/31.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate {
    
    
    /*########################################*/
    @IBOutlet weak var myTableView: UITableView!
    var parser:XMLParser!//parser:構文解析
    var items:[Item] = []//複数の記事を格納するための配列
    var item:Item?
    var currentString = ""
    /*########################################*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //headerのセルを表示
        let headerCell = myTableView.dequeueReusableCell(withIdentifier: "header")
        myTableView.tableHeaderView = headerCell?.contentView
        
    }
    //画面が表示された直後に読み込まれる。
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        startDownload()
    }
    
    //行数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //セルのインスタンス化
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel!.text = self.items[indexPath.row].title
        
        return cell
    }
    
    
    //インターネットからRSSのデータをダウンロード
    func startDownload(){
        self.items = []//古いデータと記事が重複しないように、空にする
        //ニュース記事があるWebサイトのURLを指定。
        if let url = URL(
            string: "http://togamin.com/" + "?feed=rss2"){
            //「OptionalBinding」(オプショナルバインディング)という書式。nil以外であれば「true」を返し、nilなら「false」を返す。
            print(url)
            if let parser = XMLParser(contentsOf:url){//XMLparserのインスタンス作成。
                self.parser = parser
                self.parser.delegate = self
                print("解析開始")
                self.parser.parse()
                print("解析終了")
            }
        }
    }
    //開始タグが見つかるたびに毎回呼び出される関数
    func parser(_ parser: XMLParser,didStartElement elementName:String,namespaceURI:String?,qualifiedName qName:String?,attributes attributeDict:[String:String]) {
        
        self.currentString = ""
        //print(elementName)//タグすべてプリント
        if elementName == "item"{
            //print("itemきました")
            self.item = Item()//タグ名がitemもときのみ、記事を入れる箱を作成
        }
        
    }
    //タグで囲まれた内容が見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        self.currentString = string
    }
    //終了タグが見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "title": self.item?.title = currentString
            case "link": self.item?.link = currentString
            case "pubData": self.item?.link = currentString
            case "item": self.items.append(self.item!)
        default :break
        }
        
        //解析後myTableViewをリロードする
        self.myTableView.reloadData()
        print("リロード完了")
    }
    //解析後myTableViewをリロードする.機能していない.
    func parserDidEndDocument(_ parser: XMLParser) {
        print("OK")
        self.myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

