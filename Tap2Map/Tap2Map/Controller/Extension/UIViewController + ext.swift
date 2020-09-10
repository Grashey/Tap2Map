//
//  UIViewController + ext.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 08.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

extension UIViewController {
    static var reuseID: String {
        return String(describing: self)
    }
}
