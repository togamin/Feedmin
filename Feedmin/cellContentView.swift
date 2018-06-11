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
    
    var currentLike:Bool = false//likeButtonを押したか押していないか。

    //LikeButtonが押された時、そのセルのItemをfavListに登録する。
    @IBAction func likeButton(_ sender: UIButton) {
        
        if currentLike {
            likeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            likeButton.backgroundColor = UIColor.darkGray
            favDislike()
            self.currentLike = false
        }else{
            likeButton.setTitleColor(UIColor.magenta, for: UIControlState.normal)
            
            likeButton.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 1.0)
            favLike()
            self.currentLike = true
        }
    }
    
    func favLike(){
        //やることViewControllerごとにそのViewControllerの番号、記事情報を保持できるようにし、ここでLikeを押した記事の情報を取り出せるようにする。
        print("大好き")
        //print("\(NowViewNum)")//表示されているViewCobntrollerの番号
        print("タイトル：\(self.titleLabel.text!)")
        print("画像：\(self.cellView!)")
        print("リンク：\(self.cellWenLink!)")
        
        favTitleList.append(self.titleLabel.text!)
        favImageList.append(self.cellView!.image!)
        favLinkList.append(self.cellWenLink!)
        
        print("タイトルリスト：\(favTitleList!)")
        print("画像リスト：\(favImageList!)")
        print("リンクリスト：\(favLinkList!)")
        
        
    }
    func favDislike(){
        print("大嫌い")
        
        print("タイトル：\(self.titleLabel.text!)")
        print("画像：\(self.cellView!)")
        print("リンク：\(self.cellWenLink!)")
        
        print("タイトルリスト：\(favTitleList!)")
        do{
            favTitleList.remove(at: favTitleList.index(of: self.titleLabel.text!)!)
            favImageList!.remove(at: favImageList!.index(of: self.cellView!.image!)!)
            favLinkList!.remove(at: favLinkList!.index(of: self.cellWenLink!)!)
            
        }catch{
            print("エラー",error)
        }
        
        print("タイトルリスト削除後：\(favTitleList!)")
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
