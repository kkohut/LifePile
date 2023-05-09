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
        case populateTodos
        case addTodo
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.tapticEngine) var tapticEngine
    @Dependency(\.coreData) var coreData
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .populateTodos:
                state.todos = loadTodoDTOs()
                return .none
            case .addTodo:
                let _ = coreData.todoRepository.insert(newObject: TodoDTO(title: "New Todo", id: self.uuid()))
                tapticEngine.mediumFeedback()
                state.todos = loadTodoDTOs()
                return .none
            case .todo(let id, action: .titleChanged(let newTitle)):
                let _ = coreData.todoRepository.update(updatedObject: TodoDTO(title: newTitle, id: id), id: id)
                return .none
            case .todo(let id, action: .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                switch draggedTodo.dragState {
                case .idle:
                    break
                case .complete, .delete:
                    let _ = coreData.todoRepository.delete(id: id)
                    tapticEngine.mediumFeedback()
                    state.todos = loadTodoDTOs()
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
    
    private func loadTodoDTOs() -> IdentifiedArrayOf<Todo.State> {
        IdentifiedArray(
            uniqueElements:
                try! coreData.todoRepository.getAll()
                .get()
                .map { Todo.State(title: $0.title, id: $0.id) }
        )
    }
}
