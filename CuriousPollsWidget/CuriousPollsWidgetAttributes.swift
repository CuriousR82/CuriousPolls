//
//  CuriousPollsWidgetAttributes.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-20.
//

import ActivityKit
import Foundation

struct CuriousPollsWidgetAttributes: ActivityAttributes {
    
    typealias ContentState = Poll

    public var pollId: String
    init(pollId: String) {
        self.pollId = pollId
    }
}
