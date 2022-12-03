//
//  borrow.swift
//  borrowing
//
//  Created by 小吱吱 on 11/27/22.
//

import Foundation
import UIKit


struct Borrow: Codable {
    var name: String
    var credit: Int
    var type: String
    var loc: String
    var des: String
    
    enum CodingKeys: String, CodingKey{
        case name
        case credit
        case type
        case loc
        case des
        
    }
}

struct BorrowResponse: Codable {
    let borrow: [Borrow]
}

