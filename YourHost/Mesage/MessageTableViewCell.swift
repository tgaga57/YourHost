//
//  MessageTableViewCell.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/15.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    // 送信者の顔写真
    @IBOutlet weak var senderImage: UIImageView!
    // 送信者の名前
    @IBOutlet weak var senderNameLabel: UILabel!
    // メッセージの内容
    @IBOutlet weak var messageTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
