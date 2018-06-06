//
//  getRssURL.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/06.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

/*
 URLの登録をすると、配列にrssのURLが入れ込まれる。登録したら、rssデータを読み込み、ページメニューに表示する。
 ・トップページのURLでない場合、トップページのURLに戻った上で、rssデータを取得する.
 ・様々なサイトのrssデータを取得できるようにする。
 ・rss情報がなかった場合の処理
 */
import Foundation

