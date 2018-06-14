//
//  manyViewControllers.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/05.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class siteInfo{
    var siteID:Int!
    var siteTitle:String!
    var siteURL:String!
}
var siteInfoList:[siteInfo?] = []

//登録しているWebサイトのURLの数のViewControllerが格納
var viewControllers:[UIViewController]?
//今いるViewコントローラーの番号
var NowViewNum:Int! = 0

class manyViewControllers:UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//CoreDataからサイトタイトルとサイトURLを取り出し、配列に格納。もし何も入っていなかったらデフォルトで「とがみんブログを表示する」
        siteInfoList = readSiteInfo()
        
        if siteInfoList[0] != nil {
            for info in siteInfoList{
                siteTitleList.append(info?.siteTitle)
                siteURLList.append(info?.siteURL)
                print("タイトルリスト：\(siteTitleList),URLリスト：\(siteURLList)")
            }
        }else{
            writeSiteInfo(siteID:0,siteTitle: "とがみんブログ",siteURL: "https://togamin.com/feed/")
            siteTitleList.append("とがみんブログ")
            siteURLList.append("https://togamin.com/feed/")
            print(siteTitleList,siteURLList)
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
        

        //なぜ2回繰り返す?
        for siteTitle in siteTitleList{
            //print(siteInfo)
            //ストーリボード上のwithIdentifierクラスを取得
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            
            //ViewControllerのtitleを代入
            viewController.title = siteTitle

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







