//
//  Item.swift
//  ShareVerse
//
//  Created by Rainney.W on 2022/11/24.
//

import Foundation
import UIKit

class Item {
    var title: String
    var image: UIImage
    var netId: String
    var duration: String
    var type: String
    var loc: String
    var credit: Int

    init (title: String, image: UIImage, netId: String, duration: String, type: String, loc: String, credit: Int) {
        self.title = title
        self.image = image
        self.netId = netId
        self.duration = duration
        self.type = type
        self.loc = loc
        self.credit = credit
    }
}
