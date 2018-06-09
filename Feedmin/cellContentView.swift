//
//  cellContentView.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/01.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//

import UIKit

class cellContentView:UITableViewCell{
    
    @IBOutlet weak var cellContentView: UIImageView!
    @IBOutlet weak var character: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var currentLiki:Bool = false//likeButtonを押したか押していないか。

    //LikeButtonが押された時、そのセルのItemをfavListに登録する。
    @IBAction func likeButton(_ sender: UIButton) {
        print("大好き")
        if currentLiki {
            likeButton.tintColor = UIColor.red
        }else{
            likeButton.tintColor = UIColor.lightGray
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
