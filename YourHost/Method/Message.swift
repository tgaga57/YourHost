//
//  Message.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/15.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import Foundation


class Message {
    // 送信者の名前
    var senderName:String = ""
    // メッセージ
    var message:String = ""
    // userImage
    var userProfImage:String = ""
    // 投稿情報のID
    var thePostID:String = ""
    // メッセージ送信ボタンを押したあなたのID
    var yourUID:String = ""
    // 投稿者のIDでこれからチャットする人のID
    var postUserID = ""
    // chatID
    var chatID = ""
    // 相手の名前
    var opponentName:String = ""
}
