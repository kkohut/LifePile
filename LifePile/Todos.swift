//
//  Tasks.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import ComposableArchitecture
import SwiftUI
import Foundation

struct Todos: ReducerProtocol {
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo.State> = [
            .init(title: "Clean windows"),
            .init(title: "Read")
        ]
    }
    
    enum Action: Equatable {
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .todo(id: let id, action: .removeTodo):
                state.todos.remove(id: id)
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

struct TodosView: View {
    let store: StoreOf<Todos>
    @Namespace var animation
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                
                Button(action: { }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add task")
                            .bold()
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.green)
                
                ForEachStore(self.store.scope(state: \.todos, action: Todos.Action.todo(id:action:))) {
                    TodoView(store: $0)
                }
            }
            .animation(.spring(), value: viewStore.todos)
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView(store: Store(
            initialState: Todos.State(),
            reducer: Todos())
        )
    }
}
