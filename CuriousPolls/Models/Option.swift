//
//  Option.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-18.
//

import Foundation

struct Option: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var count: Int
    var name: String
    
}
