//
//  Item.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/05/31.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

//登録しているWebサイトのURLの数のViewControllerが格納
var viewControllers:[UIViewController]?

//siteの情報を格納するリスト
var siteInfoList:[siteInfo?] = []

//記事の情報を格納するリスト
var articleInfoList:[articleInfo?] = []

//取得したデータを一時的に保存する
class Item {
    var title = ""
    var link = ""
    var pubDate = ""
    var description = ""
    var thumbImageURL = ""
    var thumbImage:UIImage!
    var fav:Bool = false
}

//CoreDataからサイト情報を格納するための構造体
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
//CoreDataからの記事情報を格納するための構造体
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

