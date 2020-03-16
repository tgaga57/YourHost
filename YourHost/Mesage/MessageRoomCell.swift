//
//  MessageRoomCell.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/16.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class MessageRoomCell: UITableViewCell {

    // userImage
    @IBOutlet weak var messageUserImage: UIImageView!
    // メッセージしている人の名前
    @IBOutlet weak var messageUserName: UILabel!
    // メッセージ
    @IBOutlet weak var messageTextView: UITextView!
    // meesage内容
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
