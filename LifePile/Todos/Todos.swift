//
//  Todos.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import ComposableArchitecture
import Foundation

struct Todos: ReducerProtocol {
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo.State> = [
            .init(title: "Clean windows"),
            .init(title: "Read"),
            .init(title: "Go for a run"),
            .init(title: "Study algebra"),
        ]
    }
    
    enum Action: Equatable {
        case addTodo
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .addTodo:
                state.todos.insert(.init(title: "New Todo"), at: 0)
                TapticEngine().mediumFeedback()
                return .none
            case .todo(id: let id, action: .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                switch draggedTodo.dragState {
                case .idle:
                    break
                case .done, .delete:
                    state.todos.remove(id: id)
                    TapticEngine().mediumFeedback()
                }
                return .none
            case .todo(id: _, action: _):
                return .none
            }
            
        }
        .forEach(\.todos, action: /Action.todo(id:action:)) {
            Todo()
        }
    }
}
