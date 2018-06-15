//
//  manyViewControllers.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/05.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

struct siteInfo{
    var siteID:Int!
    var siteTitle:String!
    var siteURL:String!
    
    init(siteID: Int, siteTitle: String,siteURL:String) {
        self.siteID = siteID
        self.siteTitle = siteTitle
        self.siteURL = siteURL
    }
}
struct articleInfo{
    var siteID:Int!
    var articleTitle:String!
    var articleURL:String!
    var thumbImageURL:String!
    var fav:Bool!
    
    init(siteID: Int, articleTitle: String,articleURL: String,thumbImageURL: String,fav: Bool) {
        self.siteID = siteID
        self.articleTitle = articleTitle
        self.articleURL = articleURL
        self.thumbImageURL = thumbImageURL
        self.fav = fav
    }
}
var siteInfoList:[siteInfo?] = []

//登録しているWebサイトのURLの数のViewControllerが格納
var viewControllers:[UIViewController]?
//今いるViewコントローラーの番号
var NowViewNum:Int! = 0

class manyViewControllers:UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//テスト---------------------------------------------------
        //CoreData初期化
        deleteAllSiteInfo()
        deleteAllArticleInfo()
        
        //CoreData読み出し
        var SInfo = readSiteInfo()
        var AInfo = readArticleInfo()
        for info in SInfo {
            print("[SiteInfo]siteID:\(info.siteID)")
            print("[SiteInfo]siteTitlr:\(info.siteTitle)")
            print("[SiteInfo]siteURL:\(info.siteURL)")
        }
        for info in AInfo {
            print("[SiteInfo]siteID:\(info.siteID)")
            print("[SiteInfo]articleTitlr:\(info.articleTitle)")
            print("[SiteInfo]siteURL:\(info.articleURL)")
        }
        
        //CoreDataへ書き込み
        writeSiteInfo(siteID:0,siteTitle:"とがみんブログ",siteURL:"http://togamin.com/rss")
        writeArticleInfo(siteID:0,articleTitle:"世界の仕組み",articleURL:"http://togamin.com/", thumbImageURL:"https://togamin.com/wp/wp-content/uploads/2018/06/pic_180612_01-300x208.png",fav:false)
        
        //CoreData読み出し
        var sInfo = readSiteInfo()
        var aInfo = readArticleInfo()
        for info in SInfo {
            print("[SiteInfo]siteID:\(info.siteID)")
            print("[SiteInfo]siteTitlr:\(info.siteTitle)")
            print("[SiteInfo]siteURL:\(info.siteURL)")
        }
        for info in AInfo {
            print("[SiteInfo]siteID:\(info.siteID)")
            print("[SiteInfo]articleTitlr:\(info.articleTitle)")
            print("[SiteInfo]siteURL:\(info.articleURL)")
        }
        
//---------------------------------------------------------
        
//CoreDataからサイトタイトルとサイトURLを取り出し、配列に格納。もし何も入っていなかったらデフォルトで「とがみんブログを表示する」
        //deleteAllSiteInfo()//CoreData全削除
        
        siteInfoList = readSiteInfo()

        
        if siteInfoList.count == 0{
            writeSiteInfo(siteID:0,siteTitle: "とがみんブログ",siteURL: "https://togamin.com/feed/")
            siteInfoList = readSiteInfo()
        }
        

        initPageMenu()

    }
    
    
    func initPageMenu() {
        
        //複数のViewControllerを用意
        viewControllers = getViewControllers()
 
        //メニューバーのレイアウト
        let option = getPageMenuOption()
        
        //PageMenuViewインスタンス作成
        let pageMenu = PageMenuView(
            viewControllers: viewControllers!,
            option: option)
        
        //デリゲート
        pageMenu.delegate = self
        
        //まだよくわからない
        pageMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //viewにpageMenuを追加する.
        view.addSubview(pageMenu)
    }
}
//どのページからどのページに遷移したかをメモする。
extension manyViewControllers: PageMenuViewDelegate {
    
    func willMoveToPage(_ pageMenu: PageMenuView, from viewController: UIViewController, index currentViewControllerIndex: Int){
        //print(currentViewControllerIndex)
    }
    
    func didMoveToPage(_ pageMenu: PageMenuView, to viewController: UIViewController, index currentViewControllerIndex: Int) {
        NowViewNum = currentViewControllerIndex
    }
}

extension manyViewControllers {

    //listの要素数の数だけViewControllerを作成
    func getViewControllers() -> [ViewController] {
        //ストーリーボード取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewControllers = [ViewController]()
        

        for info in siteInfoList{
            //print(siteInfo)
            //ストーリボード上のwithIdentifierクラスを取得
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            
            //ViewControllerのtitleを代入
            viewController.title = info?.siteTitle!

            viewControllers.append(viewController as! ViewController)
        }
        //print(viewControllers)
        return viewControllers
    }
    //ページメニューのオプション
    func getPageMenuOption() -> PageMenuOption {
        
        //ページメニューのサイズとポジション
        var option = PageMenuOption(frame:
            CGRect(x: 0, y: 20,
                   width: view.frame.size.width,
                   height: view.frame.size.height - 20))
        
        //メニューの高さ
        option.menuItemHeight = 44
        
        //メニューのサイズ
        option.menuTitleFont = .boldSystemFont(ofSize: 16)
        
        //メニュータイトルの色(未選択時)
        option.menuTitleColorNormal = .lightGray
        
        //メニュータイトルの色(選択時)
        option.menuTitleColorSelected = .black
        
        //メニューの背景色(未選択時)
        option.menuItemBackgroundColorNormal = .white
        
        //メニューの背景色
        option.menuItemBackgroundColorSelected = .white
        
        //アンダーラインの色
        option.menuIndicatorColor = .black
        return option
    }
    
}







