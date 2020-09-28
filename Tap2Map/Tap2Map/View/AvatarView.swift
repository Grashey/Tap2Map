//
//  AvatarView.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 25.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    @IBOutlet var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        avatarImageView.backgroundColor = .clear
        avatarImageView.layer.masksToBounds = true
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
}
