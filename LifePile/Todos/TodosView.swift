//
//  TodosView.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

import ComposableArchitecture
import SwiftUI

struct TodosView: View {
    let store: StoreOf<Todos>
    @Namespace var animation
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("\(viewStore.todos.count) \(viewStore.filter == .todo ? (viewStore.todos.count != 1 ? "Todos" : "Todo") : "Done")")
                        .font(.customLargeTitle)
                    
                    Spacer()
                    
                    Group {
                        Button("Todo") {
                            viewStore.send(.todoFilterTapped)
                        }
                        .tint(.accentColor.opacity(viewStore.filter == .todo ? 1.0 : 0.3))
                        
                        Button("Done") {
                            viewStore.send(.doneFilterTapped)
                        }
                        .tint(.accentColor.opacity(viewStore.filter == .done ? 1.0 : 0.3))
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.bordered)
                    .bold()
                }
                .padding()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Spacer()
                            
                            if viewStore.filter == .todo {
                                Button(action: {
                                    viewStore.send(.addButtonTapped)
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add task")
                                            .bold()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.roundedRectangle)
                                .tint(.green)
                                .compositingGroup()
                            }
                            
                            ForEachStore(self.store.scope(state: \.todos, action: Todos.Action.todo(id:action:))) {
                                TodoView(store: $0)
                            }
                        }
                        .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                        .animation(.spring(), value: viewStore.todos.count)
                    }
                }
            }
            .onAppear {
                viewStore.send(.populate)
            }
            .sheet(
                store: store.scope(state: \.$addTodo, action: { .addTodo($0) })
            ) { store in
                TodoFormView(store: store)
            }
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView(store: Store(
            initialState: Todos.State(todos: [], filter: .todo),
            reducer: Todos())
        )
    }
}
