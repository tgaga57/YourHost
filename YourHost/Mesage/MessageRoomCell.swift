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
    // meesage内容
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
