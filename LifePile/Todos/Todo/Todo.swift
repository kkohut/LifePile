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
        let id = UUID()
        var title: String
        var offset = 0.0
        var dragState = DragState.idle
        
        enum DragState {
            case idle
            case done
            case delete
        }
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case dragEnded
        case titleChanged(newTitle: String)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            state.offset = newOffset
            let originalDragState = state.dragState
            
            switch state.offset {
                case -(Double.infinity)..<(-50.0):
                state.dragState = .delete
            case -50.0..<50.0:
                state.dragState = .idle
            case 50.0...Double.infinity:
                state.dragState = .done
            default:
                fatalError("Switch over double is not exhaustive")
            }
            
            if originalDragState != state.dragState {
                TapticEngine().lightFeedback()
            }
            
            return .none
        case .dragEnded:
            switch state.dragState {
            case .idle:
                state.offset = 0
            case .done, .delete:
                break
            }
            
            return .none
        case .titleChanged(let newTitle):
            state.title = newTitle
            return .none
        }
    }
}
