//
//  TodoDTO.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import Foundation

public struct TodoDTO: Identifiable, Equatable {
    let title: String
    public let id: UUID
    let completionStatus: CompletionStatus
    let tag: TagDTO?
    let weight: Int
}
