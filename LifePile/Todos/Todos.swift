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
        var filter: CompletionStatus? = .todo
    }
    
    enum Action: Equatable {
        case populateTodos
        case todoFilterTapped
        case doneFilterTapped
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
                state.todos = loadTodos(filterBy: state.filter)
                return .none
                
            case .todoFilterTapped:
                state.filter = .todo
                state.todos = loadTodos(filterBy: state.filter)
                return .none
                
            case .doneFilterTapped:
                state.filter = .done
                state.todos = loadTodos(filterBy: state.filter)
                return .none
                
            case .addButtonTapped:
                state.todos.insert(addTodo(), at: 0)
                return .none
                
            case .todo(let id, action: .titleChanged(let newTitle)):
                let _ = updateTitle(of: state.todos.first(where: { $0.id == id })!, to: newTitle)
                return .none
                
            case .todo(let id, action: .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                
                var removed = false
                
                switch draggedTodo.dragState {
                case .idle:
                    break
                case .complete:
                    removed = complete(todo: draggedTodo)
                case .delete:
                    removed = delete(todo: draggedTodo)
                }
                
                if removed {
                    state.todos.remove(id: id)
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
    
    private func loadTodos(filterBy completionStatus: CompletionStatus?) -> IdentifiedArrayOf<Todo.State> {
        IdentifiedArray(
            uniqueElements:
                try! coreData.todoRepository.getAll()
                .get()
                .filter { $0.completionStatus == completionStatus }
                .reversed()
                .map { Todo.State(title: $0.title, id: $0.id) }
        )
    }
    
    private func addTodo() -> Todo.State {
        tapticEngine.mediumFeedback()
        return try! coreData.todoRepository
            .insert(newObject: TodoDTO(title: "New Todo", id: self.uuid(), completionStatus: .todo))
            .get()
            .state
    }
    
    private func updateTitle(of todo: Todo.State, to title: String) -> Bool {
        return try! coreData.todoRepository
            .update(to: TodoDTO(title: title, id: todo.id, completionStatus: .todo), id: todo.id)
            .get()
    }
    
    private func complete(todo: Todo.State) -> Bool {
        tapticEngine.heavyFeedback()
        return try! coreData.todoRepository
            .update(to: TodoDTO(title: todo.title, id: todo.id, completionStatus: .done), id: todo.id)
            .get()
    }
    
    private func delete(todo: Todo.State) -> Bool {
        tapticEngine.mediumFeedback()
        return try! coreData.todoRepository
            .delete(id: todo.id)
            .get()
    }
}
