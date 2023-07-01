//
//  TagDTO.swift
//  LifePile
//
//  Created by Kevin Kohut on 13.06.23.
//

import Foundation

struct TagDTO: Equatable, Hashable {
    let title: String
    
    init(named title: String) {
        self.title = title
    }
}
