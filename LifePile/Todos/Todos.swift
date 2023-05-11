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
        case addButtonTapped
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.tapticEngine) var tapticEngine
    @Dependency(\.coreData) var coreData
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .populateTodos:
                state.todos = loadTodos()
                return .none
            case .addButtonTapped:
                state.todos.insert(addTodo(), at: 0)
                return .none
            case .todo(let id, action: .titleChanged(let newTitle)):
                updateTodo(with: id, to: newTitle)
                return .none
            case .todo(let id, action: .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                switch draggedTodo.dragState {
                case .idle:
                    break
                case .complete, .delete:
                    if deleteTodo(id: id){
                        state.todos.remove(id: id)
                    }
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
    
    private func loadTodos() -> IdentifiedArrayOf<Todo.State> {
        IdentifiedArray(
            uniqueElements:
                try! coreData.todoRepository.getAll()
                .get()
                .reversed()
                .map { Todo.State(title: $0.title, id: $0.id) }
        )
    }
    
    private func addTodo() -> Todo.State {
        tapticEngine.mediumFeedback()
        return try! coreData.todoRepository
            .insert(newObject: TodoDTO(title: "New Todo", id: self.uuid()))
            .get()
            .state
    }
    
    private func updateTodo(with id: UUID, to newTitle: String) {
        let _ = coreData.todoRepository.update(to: TodoDTO(title: newTitle, id: id), id: id)
    }
    
    private func deleteTodo(id: UUID) -> Bool {
        tapticEngine.mediumFeedback()
        return try! coreData.todoRepository.delete(id: id).get()
    }
}
