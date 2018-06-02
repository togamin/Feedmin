//
//  ViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/05/31.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*TODO
 ブログ・サイトタイトル取得と表示
 投稿記事の最初の画像URLの取得(サムネイル)
 多くの記事のRSSのデータ取得方法の模索
 SNSで共有
 他のブログのRSS対応
 複数のURL対応
 時間による比較、表示順の決定
 URLの入力と保存
 おきにいり登録.選んだやつのURL保存
 下にスライドすることによるアップデート
 上にスライドすることによる過去記事の表示
 ペンギン画像ランダム表示
 テキストデータを取得してWifiにつながなくても読める(お気に位入りのみ)。
 通知来る時間帯の設定
 Infeed広告を入れる
 */

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
        
        
        //cellContentViewを呼び出し、myTableViewに登録
        let nib = UINib(nibName:"cellContentView",bundle:nil)
        myTableView.register(nib, forCellReuseIdentifier: "cell")
        myTableView.estimatedRowHeight = 250
        myTableView.rowHeight = UITableViewAutomaticDimension//自動的にセルの高さを調節する
        
 
        
    }
    
/*---------------------------------------------------*/
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as! cellContentView
        cell.titleLabel.text = self.items[indexPath.row].title
        
        return cell
    }
    //セルをタップしたら発動する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row,"だよん")
        performSegue(withIdentifier: "go",sender:nil)
    }
    //画面遷移時に呼び出される
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        print("画面遷移中")
        if let indexPath = self.myTableView.indexPathForSelectedRow{
            let item = items[indexPath.row]
            
            //遷移先のViewControllerを格納
            let controller = segue.destination as! detailViewController
            
            //遷移先の変数に代入
            controller.title = item.title
            controller.link = item.link
        }
    }
    
/*---------------------------------------------------*/
    //インターネットからRSSのデータをダウンロード
    func startDownload(){
        self.items = []//古いデータと記事が重複しないように、空にする
        //ニュース記事があるWebサイトのURLを指定。
        if let url = URL(
            string: "http://togamin.com/feed/"){
            //「OptionalBinding」(オプショナルバインディング)という書式。nil以外であれば「true」を返し、nilなら「false」を返す。
            
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
            self.item = Item()//タグ名がitemもときのみ、記事を入れる箱を作成
        }
        
    }
    //タグで囲まれた内容が見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        self.currentString = string
    }
    
    
    
    //コードの中に入っているimgタグの中のURLを取得する.
    func getImageURL(code:String)->String{
        let pattern = "src=\"(.*)\" alt"
        //(.*)の部分を抜き出す.

        let str = code
        
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        //NSRegularExpression:挟まれた文字を抜き出す。今回は[src="]と["]の間の文字列
        //caseInsensitive:多文字と小文字を区別しない。
        //try!:エラーが発生した場合にクラッシュする。
        
        let matches = regex.matches(in: str, options: [], range: NSMakeRange(0, str.characters.count))
        
        var results: [String] = []
        
        matches.forEach { (match) -> () in
            results.append( (str as NSString).substring(with: match.range(at: 1)) )
        }
        //print(results)
        
        return results[0]
    }
    
    
    
    //終了タグが見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "title":
                self.item?.title = currentString
            case "link":
                self.item?.link = currentString
            case "pubData":
                self.item?.link = currentString
            case "description":
                //print(currentString)
                self.item?.thumbImageURL = getImageURL(code: currentString)
                //print(self.item?.thumbImageURL)
            case "item": self.items.append(self.item!)
        default :break
        }
    
    
        
        
    }
    //解析後myTableViewをリロードする.機能していない.
    func parserDidEndDocument(_ parser: XMLParser){
        self.myTableView.reloadData()
        print("リロード完了")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

