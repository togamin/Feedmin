//
//  ViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/05/31.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*TODO
* お気に入り登録した記事の表示がランダム。なぜ?
*  他のブログのRSS対応

* 通知来る時間帯の設定
* Infeed広告を入れる
* 開発者プロフィール

 
* 記事登録の際ネットから検索
 
 読み込みについて。
 siteIDの記事がArticleInfoにあるかどうかを確認する。
 ↓
 CoreDataに記事情報ある場合
    * CoreDataの情報を読み込む。
    * 画像の取得をマルチスレッド処理。
    * tableに表示する。
 ↓
 CoreDataに記事情報ない場合
    * RSSの解析を行う。
    * ArticleInfoに記事情報を書き込む。
    * 画像の処理をマルチスレッド処理。
    * tableに表示.
 
 
 デザイン
 * Settingテーブル
 */


import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate{
    
    
    /*########################################*/
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var webSiteView: UIWebView!
    @IBOutlet weak var backMenu: UIButton!
    @IBOutlet weak var share: UIButton!
    
    
    
    var parser:XMLParser!//parser:構文解析
    var items:[Item] = []//複数の記事を格納するための配列
    var item:Item?
    var currentString = ""
    var imageList = [""]//サムネイル画像のデータが代入される
    //どのサイトの処理を行っているかを識別するためのID
    var viewID:Int = 0
    let queue:DispatchQueue = DispatchQueue(label: "com.togamin.queue")//マルチスレッド用
    
    var thisViewArticleInfo:[articleInfo?] = []
    var existenceArticle:Bool = false//起動する際CoreDateにArticle情報が存在するならtrue,存在しないならfalse
    var newArticleUpdate:Bool = false//記事を更新する場合のRSS解析の場合はtrue
    /*########################################*/
    
    var endFunc:Bool = false//テスト
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//テスト-------------------------------------
        
//------------------------------------------
        self.viewID = ViewControllerNow
        
        //Webサイト表示用画面の設定
        webSiteView.isHidden = true
        backMenu.isHidden = true
        share.isHidden = true
        
        //myTableView設定
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //cellContentViewを呼び出し、myTableViewに登録
        let nib = UINib(nibName:"cellContentView",bundle:nil)
        myTableView.register(nib, forCellReuseIdentifier: "cell")
        myTableView.estimatedRowHeight = 250
        myTableView.rowHeight = UITableViewAutomaticDimension//自動的にセルの高さを調節する
        
        
        print("viewID:\(self.viewID)")
        
        
        //Articleに記事が入っているかどうかの処理
        self.thisViewArticleInfo = selectSiteArticleInfo(siteID: self.viewID)
        print("記事数解析前:\(self.thisViewArticleInfo.count)")
        if self.thisViewArticleInfo.count != 0{
            self.existenceArticle = true
        }
        
        //ArticleInfoにViewIDの記事が存在しないなら、RSSデータ解析.
        if self.existenceArticle == false{
            //RSS解析とダウンロード開始
            queue.async {() -> Void in
                print("画面表示中")
                self.startDownload(siteURL: (siteInfoList[self.viewID]?.siteURL)!)
            }
            //マルチスレッド.別スレッドで画像の処理をさせることにより、その他の表示を早くすることで操作性をあげる。
            queue.async {() -> Void in
                //サムネイルの画像をItemクラスのインスタンスに代入
                print("サムネイル画像取得中")
                for i in 0..<self.items.count{
                    self.items[i].thumbImageData = self.getImageData(code: self.items[i].description)
                    
                    //CoreDataに記事情報を保存
                    writeArticleInfo(siteID:self.viewID,articleTitle:self.items[i].title,updateDate:self.items[i].pubDate!,articleURL:self.items[i].link,thumbImageData:self.items[i].thumbImageData!,fav:false)
                    
                    //NSDataからUIImageに変換
                    self.items[i].thumbImage = UIImage(data:self.items[i].thumbImageData! as Data)!
                }
                //現在のviewに関連するサイトだけの記事を取得.
                self.thisViewArticleInfo = selectSiteArticleInfo(siteID: self.viewID)
                print("記事数解析後：\(self.thisViewArticleInfo.count)")
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
        print("ViewID:\(self.viewID)")
        queue.async {() -> Void in
            self.rssUpdate(siteURL:(siteInfoList[self.viewID]?.siteURL)!)
            //データの読み込み
            self.thisViewArticleInfo = selectSiteArticleInfo(siteID: self.viewID)
            //テーブルを再読み込みする。
            self.myTableView.reloadData()
        }
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
        var cellNum:Int?
        if self.existenceArticle{
            cellNum = self.thisViewArticleInfo.count
        }else{
            cellNum = items.count
        }
        return cellNum!
    }
    
    //セルのインスタンス化
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as! cellContentView
        
        cell.cellIndex = indexPath.row
        
        //元々記事がCoreDataに存在していた場合、それを呼び出し。そうでない場合、Itemから呼び出す.処理を早くするため。
        if self.existenceArticle{
            cell.titleLabel.text = self.thisViewArticleInfo[indexPath.row]?.articleTitle!
            cell.cellWebLink = self.thisViewArticleInfo[indexPath.row]?.articleURL!
            cell.cellView.image = UIImage(data:self.thisViewArticleInfo[indexPath.row]?.thumbImageData! as! Data)
        }else{
            cell.titleLabel.text = self.items[indexPath.row].title
            cell.cellWebLink = self.items[indexPath.row].link
            
            if items[indexPath.row].thumbImage != nil {
                cell.cellView.image = items[indexPath.row].thumbImage
            }else{//画像が取得されるまではデフォルト画像
                cell.cellView.image = UIImage(named: "default.png")
            }
        }
        
        //favがtrueならLIKEのデザイン変更.favに代入される前に動作するとエラーが出てしまうので、代入されるたびに動作させるために、別スレッドで処理。
        queue.async {() -> Void in
            //たまにインデックスアウトオブレンジ.後で考える
            cell.currentLike = self.thisViewArticleInfo[indexPath.row]!.fav
            if cell.currentLike {
                cell.likeButton.setTitleColor(UIColor.magenta, for: UIControlState.normal)
                cell.likeButton.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 1.0)
            }else{
                cell.likeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                cell.likeButton.backgroundColor = UIColor.darkGray
            }
        }
        
        return cell
    }
    
    //shareする際のURL格納
    var shareURL = URL(string: "https://togamin.com/")
    //セルをタップしたら発動する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: (self.thisViewArticleInfo[indexPath.row]?.articleURL)!){
            self.shareURL = url
            let request = URLRequest(url:url)
            self.webSiteView.loadRequest(request)
            webSiteView.isHidden = false
            backMenu.isHidden = false
            share.isHidden = false
        }
    }

    @IBAction func backMenu(_ sender: UIButton) {
        webSiteView.isHidden = true
        backMenu.isHidden = true
        share.isHidden = true
    }
    // シェア用ボタン
    @IBAction func share(_ sender: UIButton) {
        func showMessage(){print("表示完了")}
        let controller = UIActivityViewController(activityItems: [self.shareURL], applicationActivities:nil)
        self.present(controller, animated: true,completion:showMessage)
    }
    
    
//記事を更新する際の関数
    
    func rssUpdate(siteURL:String){
        newArticleUpdate = true
        self.startDownload(siteURL: siteURL)
        print("テスト:self.startDownload完了")
        newArticleUpdate = false
        self.existenceArticle = true
        self.endFunc = false
        //新規データの書き込み
        for i in 0..<self.items.count{
            self.items[i].thumbImageData = self.getImageData(code: self.items[i].description)
            print("テストitemsの中身:\(self.items[i].title)")
            writeArticleInfo(siteID:self.viewID,articleTitle:self.items[i].title,updateDate:self.items[i].pubDate!,articleURL:self.items[i].link,thumbImageData:self.items[i].thumbImageData!,fav:false)
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
        
        if self.endFunc == false{
            self.currentString = ""
            //print(elementName)//タグすべてプリント
            if elementName == "item"{
                self.item = Item()//タグ名がitemのときのみ、記事を入れる箱を作成
            }
        }
        
    }
    //タグで囲まれた内容が見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        if self.endFunc == false{
            self.currentString = string
        }
    }
    
    
    //終了タグが見つかるたびに呼び出されるメソッド。
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print(elementName)
        if self.endFunc == false{
            switch elementName {
                case "title":
                    self.item?.title = currentString
                case "link":
                    self.item?.link = currentString
                    if newArticleUpdate {
                        if getSameArticle(articleURL:currentString).count != 0{
                            //print("テスト:\(currentString)")
                            self.endFunc = true
                        }
                    }
                case "pubDate":
                    self.item?.pubDate = self.pubDate(pubDate: currentString)
                case "description":
                    self.item?.description = currentString
                case "item": self.items.append(self.item!)
            default :break
            }
        }
    }
    //pubDataの情報を扱いやすいデータに変換.
    //[Sun, 17 Jun 2018 12:00:22 +0000]を
    //[2018-06-17 12:00:22 +0000]に変換.
    func pubDate(pubDate:String)->Date?{
        //print("pubDate0:\(pubDate)")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
        let getDate = dateFormatter.date(from: pubDate)
        //print("pubDate1:\(getDate!)")
        return getDate
    }
    
    //コードの中に入っているimgタグの中のURLを取得し,画像をNSDataとして出力.
    func getImageData(code:String)->NSData!{
        
        var result:UIImage?
        var thumbImageURL:String?
        var thumbImageData:NSData?
        
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
                thumbImageURL = (str2 as NSString).substring(with: match.range(at: 1))
            }
            let url = NSURL(string:thumbImageURL!)
            thumbImageData = NSData(contentsOf: url! as URL)
        }else if str2 == nil{
            thumbImageData = UIImageJPEGRepresentation(UIImage(named:"default.png")!, 1.0)! as NSData//圧縮率
        }
            
        //print("画像のURL(getImageURL):\(thumbImageURL!)")
        return thumbImageData
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



