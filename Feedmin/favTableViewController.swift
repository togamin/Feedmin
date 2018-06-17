//
//  favTableViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/09.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//



import UIKit


class favTableViewController:UITableViewController{
    
    @IBOutlet weak var favTableView: UITableView!
    var favArticleList:[articleInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        
        //favCellViewを呼び出し、favTableViewに登録
        let nib = UINib(nibName:"favCellView",bundle:nil)
        favTableView.register(nib, forCellReuseIdentifier: "favCell")
        favTableView.estimatedRowHeight = 250
        favTableView.rowHeight = UITableViewAutomaticDimension//自動的にセルの高さを調節する
        
        favArticleList = readFav()
        
        print("リフレッシュコントローラー作成")
        //リフレッシュコントロールを作成する。
        let refresh = UIRefreshControl()
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle = NSAttributedString(string: "読込中")
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。関数をうまく呼び出せていない
        refresh.addTarget(self, action: #selector(favTableViewController.relode(_: )), for: .valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.refreshControl = refresh
        print("リフレッシュコントローラーの設定完了")
        
        
    }
    
    
    
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    @objc func relode(_ sender: UIRefreshControl){
        print("再読み込み")
        favArticleList = readFav()
        //テーブルを再読み込みする。
        self.favTableView.reloadData()
        //読込中の表示を消す。
        refreshControl?.endRefreshing()
    }
    
 
 
 

    //行数を決める
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArticleList!.count
    }

    //セルのインスタンス化
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "favCell",for:indexPath) as! favCellView
        
        cell.favTitle.text = self.favArticleList![indexPath.row].articleTitle
        cell.favImageView.image = UIImage(data:self.favArticleList![indexPath.row].thumbImageData as Data)!
        
        //cell.mainTitle.text = self.favArticleList![indexPath.row]
        
        return cell
    }
    
    //セルをタップしたら発動する処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTofavWeb",sender:nil)
    }
    //画面遷移時に呼び出される
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        print("画面遷移中")
        if let indexPath = self.favTableView.indexPathForSelectedRow{
            let title = self.favArticleList![indexPath.row].articleTitle
            let link = self.favArticleList![indexPath.row].articleURL
            //遷移先のViewControllerを格納
            let controller = segue.destination as! fabWevViewController
            
            //遷移先の変数に代入
            //controller.title = title
            controller.link = link
        }
    }
    //セルを横にスライドさせた時に呼ばれる
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("消すね??")
            let articleURL = self.favArticleList![indexPath.row].articleURL
            updateFav(siteID:NowViewNum,articleURL:articleURL!,bool:false)
            favArticleList = readFav()
            //テーブルを再読み込みする。
            self.favTableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
