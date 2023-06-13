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
    }
    
    enum Action: Equatable {
        case titleChanged(newTitle: String)
        case saveButtonTapped
    }
    
    @Dependency(\.tapticEngine) var tapticEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .titleChanged(let newTitle):
            state.title = newTitle
            return .none
            
        case .saveButtonTapped:
            return .none
        }
    }
}
