//
//  TodoMO+dto.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import Foundation

extension TodoMO {
    var dto: TodoDTO {
        TodoDTO(
            title: self.title!,
            id: self.id!,
            completionStatus: CompletionStatus(rawValue: self.completionStatus!)!,
            tag: tag != nil ? TagDTO(named: tag!) : nil
        )
    }
}
