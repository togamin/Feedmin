//
//  ViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/05/31.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*TODO
* ナビゲーションについて.WebViewから前のViewに戻る方法(上手くいかない)
* URL登録ボタン押してから、再読み込みしない。(上手くいかない)
* タップされた時のセルの情報を取得する方法
* 記事情報にお気に入りかどうかの情報を入れる(True false)
    * Likeでfalseをtrueに、DisLikeでfalseに。
 
 
 お気にいりようのnibファイル作成。
 リンクとタイトルの記入欄とUserDefaultsに登録する方法
 スライドで登録しているURLを削除できるようにする。
 スライドで登録しているお気に入り削除できるようにする。
 おきにいり登録.選んだやつのURL保存.テキストデータ保存
 ブログ・サイトタイトル取得と表示
 
 SNSで共有
 他のブログのRSS対応

 下にスライドすることによるアップデート
 refreshController
 ペンギン画像ランダム表示
 通知来る時間帯の設定
 Infeed広告を入れる
 開発者プロフィール
 */

/*このファイルで行なっている作業の概要
 
 
 
 */


import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate{
    
    
    /*########################################*/
    @IBOutlet weak var myTableView: UITableView!
    var parser:XMLParser!//parser:構文解析
    var items:[Item] = []//複数の記事を格納するための配列
    var item:Item?
    var currentString = ""
    var imageList = [""]//サムネイル画像のデータが代入される
    //let queue:DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)//マルチスレッド用
    let queue:DispatchQueue = DispatchQueue(label: "com.togamin.queue")//マルチスレッド用
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
        
        
        //print("\(ViewControllerNow!)番目のView")
        
        

        queue.async {() -> Void in
            print("画面表示中")
            self.startDownload(siteURL: siteURLList[ViewControllerNow])
        }

        
        
        
        
        //マルチスレッド.別スレッドで画像の処理をさせることにより、その他の表示を早くすることで操作性をあげる。
        queue.async {() -> Void in
            //サムネイルの画像をItemクラスのインスタンスに代入
            print("サムネイル画像取得中")
            for i in 0..<self.items.count{
                self.items[i].thumbImage = self.getImage(code:self.items[i].description)
            //print(self.items[i].thumbImage)
            }
        }
        
        
        
        print("リフレッシュコントローラー作成")
        //リフレッシュコントロールを作成する。
        let refresh = UIRefreshControl()
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle = NSAttributedString(string: "読込中")
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。関数をうまく呼び出せていない
        refresh.addTarget(self, action: #selector(ViewController.relode(_: )), for: .valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        myTableView.addSubview(refresh)
        print("リフレッシュコントローラーの設定完了")
        
        
    }
    //テーブルビュー引っ張り時の呼び出しメソッド
    @objc func relode(_ sender: UIRefreshControl){
        print("再読み込み")
        //テーブルを再読み込みする。
        myTableView.reloadData()
        //読込中の表示を消す。
        sender.endRefreshing()
    }
    
    
/*---------------------------------------------------*/
    //画面が表示された直後に読み込まれる。
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
/*---------------------------------------------------*/
    //行数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //セルのインスタンス化
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as! cellContentView
        
        
        
        cell.titleLabel.text = self.items[indexPath.row].title
        cell.cellWenLink = self.items[indexPath.row].link
        //print(cell.titleLabel.text)
        
        //print("Itemの中のサムネイル表示\(items[indexPath.row].thumbImage)")
        
        if items[indexPath.row].thumbImage != nil{
            cell.cellView.image = items[indexPath.row].thumbImage
            
            //print(items[indexPath.row].thumbImage)
            //print("サムネイル画像取得完了")
        }else{
            cell.cellView.image = UIImage(named: "default.png")
            //print("default画像")
        }

        
        return cell
    }
    
    
    //セルをタップしたら発動する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    //インターネットからRSSのデータをダウンロード＆解析
    func startDownload(siteURL:String){
        self.items = []//古いデータと記事が重複しないように、空にする
        //ニュース記事があるWebサイトのURLを指定。
        if let url = URL(
            string: siteURL){
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
    
    
    //終了タグが見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print(elementName)
        switch elementName {
            case "title":
                self.item?.title = currentString
            case "link":
                self.item?.link = currentString
            case "pubData":
                self.item?.pubDate = currentString
            case "description":
                self.item?.description = currentString
            case "item": self.items.append(self.item!)
        default :break
        }
    }
    //コードの中に入っているimgタグの中のURLを取得しUIImageに変換。画像のURLがない場合、デフォルト画像を取得する.
    func getImage(code:String)->UIImage?{
        
        var result:UIImage?
        var url:String?
        
        let pattern1 = "<img(.*)/>"
        let pattern2 = "src=\"(.*?)\""
        //(.*)の部分を抜き出す.
        
        let str1:String = code
        //print(str1)
        
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: .caseInsensitive)
        let regex2 = try! NSRegularExpression(pattern: pattern2, options: .caseInsensitive)
        
        //NSRegularExpression:挟まれた文字を抜き出す。
        //caseInsensitive:多文字と小文字を区別しない。
        //try!:エラーが発生した場合にクラッシュする。
        
        let matches1 = regex1.matches(in: str1, options: [], range: NSMakeRange(0, str1.characters.count))
        
        var str2:String!
        
        matches1.forEach { (match) -> () in
            str2 = (str1 as NSString).substring(with: match.range(at: 1))
        }
        //str2には[<img]~[/>]までの文字が入る.なければ[nil]
        //print("str2:\(str2)")
        
        if str2 != nil{
            
            //imgタグの中のURLの部分のみを取得
            let matches2 = regex2.matches(in: str2!, options: [], range: NSMakeRange(0, str2.characters.count))
            
            matches2.forEach { (match) -> () in
                url = (str2 as NSString).substring(with: match.range(at: 1))
            }
            
            //URLから画像データに変換
            let url = NSURL(string:url!)
            let imageData = NSData(contentsOf: url! as URL)
            result = UIImage(data:imageData! as Data)!
            
            
        }else if str2 == nil{
            result = UIImage(named:"default.png")
        }
       
        //print("result:\(result)")

        return result
    }
    //解析後myTableViewをリロードする.
    func parserDidEndDocument(_ parser: XMLParser){
        self.myTableView.reloadData()
        print("RSS解析後のリロード完了")
    }
    
    /*---------------------------------------------------*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



