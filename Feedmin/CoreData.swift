//
//  CoreData.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/13.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit
import CoreData

//SiteInfoへのデータの書き込み
func writeSiteInfo(titleText:String,urlText:String){
    print("SiteInfoのCoreDataへの登録")
    //AppDelegateを使う用意をしておく
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //Entityを操作するためのオブジェクトを作成
    let viewContext = appDelegate.persistentContainer.viewContext
    //SiteInfoエンティティオブジェクト作成
    let SiteInfo = NSEntityDescription.entity(forEntityName: "SiteInfo", in: viewContext)
    //SiteInfoエンティティに行を挿入するためのオブジェクトを作成
    let newRecode = NSManagedObject(entity: SiteInfo!, insertInto: viewContext)
    //値のセット
    newRecode.setValue(titleText, forKey: "siteTitle")
    newRecode.setValue(urlText, forKey: "siteURL")
    do{
        //レコード(行)の即時保存
        try viewContext.save()
        print("SiteInfo登録完了")
    }catch{
        print("error")
    }
}



//SiteInfoのデータ読み込み用
func readSiteInfo() {
    //AppDelegateを使う用意をしておく
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //Entityを操作するためのオブジェクトを作成
    let viewContext = appDelegate.persistentContainer.viewContext
    //どのエンティティからdataを取得してくるかの設定
    let query:NSFetchRequest<SiteInfo> = SiteInfo.fetchRequest()
    do{
        //データを一括取得
        let fetchResults = try! viewContext.fetch(query)
        //データの取得
        for result:AnyObject in fetchResults{
            let siteTitle:String? = result.value(forKey:"siteTitle") as? String
            let siteURL:String? = result.value(forKey:"siteURL") as? String
            print("[CoreData]サイトタイトル：\(siteTitle!)サイトURL:\(siteURL!)")
        }
    }
}
