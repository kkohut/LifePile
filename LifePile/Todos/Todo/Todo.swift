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
        let id: UUID
        var offset = 0.0
        var dragState = DragState.idle
        
        enum DragState {
            case idle
            case complete
            case delete
        }
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case dragEnded
        case titleChanged(newTitle: String)
    }
    
    @Dependency(\.tapticEngine) var tapticEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            state.offset = newOffset
            let originalDragState = state.dragState
            
            state.dragState = dragState(for: newOffset)
            
            if originalDragState != state.dragState {
                return .fireAndForget {
                    tapticEngine.lightFeedback()
                }
            } else {
                return .none
            }
        case .dragEnded:
            switch state.dragState {
            case .idle:
                state.offset = 0
            case .complete, .delete:
                break
            }
            
            return .none
        case .titleChanged(let newTitle):
            state.title = newTitle
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
