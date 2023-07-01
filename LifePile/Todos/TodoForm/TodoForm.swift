//
//  TodoForm.swift
//  LifePile
//
//  Created by Kevin Kohut on 04.06.23.
//

import ComposableArchitecture
import Foundation

struct TodoForm: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: UUID
        var title: String
        var completionStatus: CompletionStatus
        var tag: TagDTO?
        var isTitleFocused = true
        let operation: Operation
        let defaultTags = [
            TagDTO(named: "Housekeeping"),
            TagDTO(named: "Study"),
            TagDTO(named: "Work"),
            TagDTO(named: "Social"),
            TagDTO(named: "Sports"),
            TagDTO(named: "Hobbies")
        ]
        
        var dto: TodoDTO {
            TodoDTO(title: title, id: id, completionStatus: completionStatus, tag: tag)
        }
    }
    
    enum Action: Equatable {
        case titleChanged(newTitle: String)
        case cancelButtonTapped
        case saveButtonTapped
        case tagChanged(tag: TagDTO?)
    }
    
    enum Operation: Equatable {
        case add
        case edit
    }
    
    @Dependency(\.tapticEngine) var tapticEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cancelButtonTapped:
            return .none
            
        case .titleChanged(let newTitle):
            state.title = newTitle
            return .none
            
        case .saveButtonTapped:
            return .none
            
        case .tagChanged(let tag):
            state.tag = tag
            return .none
        }
    }
}