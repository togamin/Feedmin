//
//  cellContentView.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/01.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class cellContentView:UITableViewCell{
    
    @IBOutlet weak var cellView: UIImageView!
    @IBOutlet weak var character: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var cellWenLink:String!
    
    var cellIndex:Int!
    var currentLike:Bool = false//likeButtonを押したか押していないか。

    //LikeButtonが押された時、そのセルのItemをfavListに登録する。
    @IBAction func likeButton(_ sender: UIButton) {
        
        if currentLike {
            likeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            likeButton.backgroundColor = UIColor.darkGray
            print("cellIndex：\(cellIndex)")
            updateFav(siteID: NowViewNum, articleURL: cellWenLink, bool: false)
            favDislike()
            self.currentLike = false
        }else{
            likeButton.setTitleColor(UIColor.magenta, for: UIControlState.normal)
            
            likeButton.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 1.0)
            print("cellIndex：\(cellIndex)")
            updateFav(siteID: NowViewNum, articleURL: cellWenLink, bool: true)
            favLike()
            self.currentLike = true
        }
    }
    
    func favLike(){
        print("大好き")
    }
    func favDislike(){
        print("大嫌い")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
