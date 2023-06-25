//
//  TodoDTO+state.swift
//  LifePile
//
//  Created by Kevin Kohut on 11.05.23.
//

import Foundation

extension TodoDTO {
    var state: Todo.State {
        .init(title: self.title, completionStatus: self.completionStatus, id: self.id, tag: TagDTO(named: self.title))
    }
}
