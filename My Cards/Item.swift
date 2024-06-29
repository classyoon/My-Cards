//
//  Item.swift
//  My Cards
//
//  Created by Conner Yoon on 6/29/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
