//
//  TagDTO.swift
//  LifePile
//
//  Created by Kevin Kohut on 13.06.23.
//

import Foundation

struct TagDTO: Equatable {
    let title: String
    
    init?(named title: String?) {
        guard let title else {
            return nil
        }
        
        self.title = title
    }
}
