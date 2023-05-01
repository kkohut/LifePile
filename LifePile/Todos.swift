//
//  Todos.swift
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
                mediumVibration()
                return .none
            case .todo(id: let id, action: .dragEnded):
                let draggedTodo = state.todos.first(where: { $0.id == id })!
                switch draggedTodo.dragState {
                case .idle:
                    break
                case .done, .delete:
                    state.todos.remove(id: id)
                    mediumVibration()
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
    
    private func mediumVibration() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

struct TodosView: View {
    let store: StoreOf<Todos>
    @Namespace var animation
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("\(viewStore.todos.count) Todos")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Spacer()
                            
                            Button(action: {
                                viewStore.send(.addTodo)
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add task")
                                        .bold()
                                }
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.green)
                            .compositingGroup()
                            
                            ForEachStore(self.store.scope(state: \.todos, action: Todos.Action.todo(id:action:))) {
                                TodoView(store: $0)
                            }
                        }
                        .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                        .animation(.spring(), value: viewStore.todos.count)
                    }
                }
            }
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
