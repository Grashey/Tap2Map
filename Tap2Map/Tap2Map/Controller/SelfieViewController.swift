//
//  SelfieViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 24.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class SelfieViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
