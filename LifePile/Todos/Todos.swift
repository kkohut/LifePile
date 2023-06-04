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
        var todos: IdentifiedArrayOf<Todo.State>
        var filter: CompletionStatus
        var todoInCreation: Todo.State?
        var isShowingCreationSheet: Bool
    }
    
    enum Action: Equatable {
        case todoFilterTapped
        case doneFilterTapped
        case populate
        case populateWith(todos: IdentifiedArrayOf<Todo.State>)
        case addButtonTapped
        case setCreationSheet(isPresented: Bool)
        case updateTodoInCreation(updatedTodo: TodoDTO)
        case add(todo: Todo.State)
        case todo(id: Todo.State.ID, action: Todo.Action)
        case remove(todo: Todo.State)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.tapticEngine) var tapticEngine
    @Dependency(\.coreData) var coreData
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .todoFilterTapped:
                state.filter = .todo
                return .run { send in
                    await send(.populate)
                }
                
            case .doneFilterTapped:
                state.filter = .done
                return .run { send in
                    await send(.populate)
                }
                
            case .populate:
                return .run { [filter = state.filter] send in
                    await send(.populateWith(todos: loadTodos(filterBy: filter)))
                }
                
            case let .populateWith(todos):
                state.todos = todos
                return .none
                
            case .addButtonTapped:
                state.todoInCreation = Todo.State(title: "New Todo", completionStatus: .todo, id: uuid())
                    state.isShowingCreationSheet = true
                
                return .run { send in
                    tapticEngine.mediumFeedback()
                    await send(.add(todo: try! addTodo().get().state))
                }
                
            case .setCreationSheet(isPresented: true):
                state.isShowingCreationSheet = true
                return .none
                
            case .setCreationSheet(isPresented: false):
                state.isShowingCreationSheet = false
                return .none
                
            case let .updateTodoInCreation(updatedTodo):
                state.todoInCreation = updatedTodo.state
                return .none
                
            case let .add(todo):
                state.todos.insert(todo, at: 0)
                return .none
                
            case let .todo(id, .titleChanged(newTitle)):
                let todo = state.todos.first(where: { $0.id == id })!
                return .fireAndForget {
                    let _ = try! updateTitle(of: todo, to: newTitle).get()
                }
                
            case let .todo(id, .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                
                return .run { [todo = draggedTodo] send in
                    var removed = false
                    
                    switch draggedTodo.dragState {
                    case .idle:
                        break
                    case .complete:
                        removed = try! complete(todo: todo).get()
                        tapticEngine.heavyFeedback()
                    case .delete:
                        removed = try! delete(todo: todo).get()
                        tapticEngine.mediumFeedback()
                    }
                    
                    if removed {
                        await send(.remove(todo: todo))
                    }
                }
                
            case let .remove(todo):
                state.todos.remove(todo)
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
                .map { Todo.State(title: $0.title, completionStatus: $0.completionStatus, id: $0.id) }
        )
    }
    
    private func addTodo() -> Result<TodoDTO, Error> {
        coreData.todoRepository.insert(newObject: TodoDTO(title: "New Todo",
                                                          id: self.uuid(),
                                                          completionStatus: .todo))
    }
    
    private func updateTitle(of todo: Todo.State, to title: String) -> Result<Bool, Error> {
        coreData.todoRepository.update(to: TodoDTO(title: title,
                                                   id: todo.id,
                                                   completionStatus: .todo),
                                       id: todo.id)
    }
    
    private func complete(todo: Todo.State) -> Result<Bool, Error> {
        coreData.todoRepository.update(to: TodoDTO(title: todo.title,
                                                   id: todo.id,
                                                   completionStatus: .done),
                                       id: todo.id)
    }
    
    private func delete(todo: Todo.State) -> Result<Bool, Error> {
        coreData.todoRepository.delete(id: todo.id)
    }
}
