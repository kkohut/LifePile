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
        var todos: IdentifiedArrayOf<Todo.State> = []
    }
    
    enum Action: Equatable {
        case addTodo
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .addTodo:
                state.todos.insert(.init(title: "New Todo", id: self.uuid()), at: 0)
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
