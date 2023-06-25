//
//  Todo.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import ComposableArchitecture
import Foundation

struct Todo: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var title: String
        var completionStatus: CompletionStatus
        let id: UUID
        var offset = 0.0
        var dragState = DragState.idle
        let tag: TagDTO?
        
        enum DragState {
            case idle
            case complete
            case delete
        }
        
        var dto: TodoDTO {
            TodoDTO(title: title, id: id, completionStatus: completionStatus, tag: tag)
        }
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case dragEnded
        case saveButtonTapped
        case editTodo
    }
    
    @Dependency(\.tapticEngine) var tapticEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            guard state.completionStatus != .done else {
                return .none
            }
            
            state.offset = newOffset
            let originalDragState = state.dragState
            
            state.dragState = dragState(for: newOffset)
            
            if originalDragState != state.dragState {
                return .fireAndForget {
                    tapticEngine.lightFeedback()
                }
            }
            
            return .none
            
        case .dragEnded:
            switch state.dragState {
            case .idle:
                state.offset = 0
            case .complete, .delete:
                break
            }
            
            return .none
            
        case .saveButtonTapped:
            return .none
            
        case .editTodo:
            return .none
        }
    }
    
    private func dragState(for offset: Double) -> State.DragState {
        let threshold = 50.0
        switch offset {
        case -(Double.infinity)..<(-threshold):
            return .delete
        case -threshold..<threshold:
            return .idle
        case threshold...Double.infinity:
            return .complete
        default:
            fatalError("Switch over double is not exhaustive")
        }
    }
}
