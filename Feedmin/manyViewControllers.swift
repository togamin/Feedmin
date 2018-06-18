//
//  manyViewControllers.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/05.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit




class manyViewControllers:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
//テスト---------------------------------------------------
        //CoreData初期化
        //deleteAllSiteInfo()
        deleteAllArticleInfo()//もしCoreDataに記事が入っている場合、過去記事URLと同じURLが出るまで行う.その処理を書いたら、記事の初期化消す。
//--------------------------------------------------------
        
        
//ステータスバーの背景色変更.UIViewを作成し追加することで実現
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
            statusBar.backgroundColor = UIColor(red: 0, green: 0.02, blue: 0.06, alpha: 0.85)
            view.addSubview(statusBar)

        
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
        option.menuTitleColorSelected = .white
        
        //メニューの背景色(未選択時)
        option.menuItemBackgroundColorNormal = UIColor(red: 0, green: 0.02, blue: 0.06, alpha: 0.61)
        
        //メニューの背景色
        option.menuItemBackgroundColorSelected = UIColor(red: 0, green: 0.02, blue: 0.06, alpha: 0.61)
        
        //アンダーラインの色
        option.menuIndicatorColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 0.8)
        return option
    }
    
}







