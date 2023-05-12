//
//  TodoDTO.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import Foundation

struct TodoDTO: Identifiable {
    let title: String
    let id: UUID
    let completionStatus: CompletionStatus
}
