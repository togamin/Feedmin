//
//  favTableViewController.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/09.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

var favTitle:[String]! = []
var favImage:[UIImageView]! = []
var favLink:[String]! = []

var favItemList:[favItem] = []

class favItem {
    var title = ""
    var URL = ""
    var thumbImage:UIImage!
}




import UIKit


class favTableViewController:UITableViewController{
    
    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //cellContentViewを呼び出し、myTableViewに登録
        let nib = UINib(nibName:"cellContentView",bundle:nil)
        favTableView.register(nib, forCellReuseIdentifier: "favCell")
        
        
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
        //テーブルを再読み込みする。
        tableView.reloadData()
        //読込中の表示を消す。
        refreshControl?.endRefreshing()
    }

    //行数を決める
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favTitle.count
    }

    //セルのインスタンス化
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "favCell",for:indexPath) as! cellContentView
        cell.titleLabel.text = favTitle[indexPath.row]
        cell.cellContentView = favImage[indexPath.row]
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
            let title = favTitle[indexPath.row]
            let link = favLink[indexPath.row]
            //遷移先のViewControllerを格納
            let controller = segue.destination as! fabWevViewController
            
            //遷移先の変数に代入
            //controller.title = title
            controller.link = link
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
