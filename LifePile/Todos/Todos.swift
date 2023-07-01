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
        @PresentationState var todoForm: TodoForm.State?
    }
    
    enum Action: Equatable {
        case todoFilterTapped
        case doneFilterTapped
        case populate
        case populateWith(todos: IdentifiedArrayOf<Todo.State>)
        case addButtonTapped
        case add(todo: Todo.State)
        case saveTodoForm(PresentationAction<TodoForm.Action>)
        case todo(id: Todo.State.ID, action: Todo.Action)
        case remove(todoID: UUID)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.tapticEngine) var tapticEngine
    @Dependency(\.coreData) var coreData
    
    var body: some ReducerProtocolOf<Self> {
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
                state.todoForm = TodoForm.State(id: uuid(), title: "New Todo", completionStatus: .todo, operation: .add)
                return .run { send in
                    tapticEngine.mediumFeedback()
                }
                
            case let .add(todo):
                state.todos.insert(todo, at: 0)
                return .none
                
            case .saveTodoForm(.presented(.saveButtonTapped)):
                guard let todoForm = state.todoForm else {
                    return .none
                }
                
                state.todoForm = nil
                
                return .run { send in
                    if todoForm.operation == .add {
                        _ = add(todo: todoForm.dto)
                    } else {
                        _ = update(todoDTO: todoForm.dto)
                    }
                    await send(.populate)
                }
                
            case .saveTodoForm(.presented(.cancelButtonTapped)):
                state.todoForm = nil
                return .none
                
            case .saveTodoForm(.presented(.delete)):
                guard let todoForm = state.todoForm else {
                    return .none
                }
                
                state.todoForm = nil
                
                return .run { send in
                    let removed = try! delete(todoID: todoForm.id).get()
                    if removed {
                        await send(.remove(todoID: todoForm.id))
                    }
                }
                
            case .saveTodoForm:
                return .none
                
            case let .todo(id, .editTodo):
                let todoToEdit = state.todos.first(where: { $0.id == id})!
                state.todoForm = TodoForm.State(
                    id: todoToEdit.id,
                    title: todoToEdit.title,
                    completionStatus: todoToEdit.completionStatus,
                    tag: todoToEdit.tag,
                    operation: .edit
                )
                return .none
                
            case let .todo(id, .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                
                return .run { [todo = draggedTodo] send in
                    var removed = false
                    
                    switch draggedTodo.dragState {
                    case .idle:
                        break
                    case .complete:
                        removed = try! update(
                            todoDTO: TodoDTO(
                                title: todo.title,
                                id: todo.id,
                                completionStatus: .done,
                                tag: todo.tag
                            )
                        ).get()
                        tapticEngine.heavyFeedback()
                    case .delete:
                        removed = try! delete(todoID: todo.id).get()
                        tapticEngine.mediumFeedback()
                    }
                    
                    if removed {
                        await send(.remove(todoID: todo.id))
                    }
                }
                
            case .todo(id: _, action: _):
                return .none
                
            case let .remove(todoID):
                state.todos.remove(id: todoID)
                return .none
            }
        }
        .forEach(\.todos, action: /Action.todo(id:action:)) {
            Todo()
        }
        .ifLet(\.$todoForm, action: /Action.saveTodoForm) {
            TodoForm()
        }
    }
    
    
    private func loadTodos(filterBy completionStatus: CompletionStatus?) -> IdentifiedArrayOf<Todo.State> {
        IdentifiedArray(
            uniqueElements:
                try! coreData.todoRepository.getAll()
                .get()
                .filter { $0.completionStatus == completionStatus }
                .reversed()
                .map { Todo.State(title: $0.title, completionStatus: $0.completionStatus, id: $0.id, tag: $0.tag) }
        )
    }
    
    private func add(todo: TodoDTO) -> Result<TodoDTO, Error> {
        coreData.todoRepository.insert(newObject: todo)
    }
    
    private func update(todoDTO: TodoDTO) -> Result<Bool, Error> {
        coreData.todoRepository.update(to: todoDTO,
                                       id: todoDTO.id)
    }
    
    private func delete(todoID: UUID) -> Result<Bool, Error> {
        coreData.todoRepository.delete(id: todoID)
    }
}

enum SheetAction<Action> {
    case dismiss
    case presented(Action)
}

extension SheetAction: Equatable where Action: Equatable {}
