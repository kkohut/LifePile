//
//  TodosView.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

import ComposableArchitecture
import SwiftUI
import Charts

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
                
                Chart(viewStore.todosByAmount.sorted(by: >), id: \.key) { tag in
                    BarMark(
                        x: .value("Count", tag.value),
                        stacking: .normalized
                    )
                    .annotation(position: .overlay) {
                        Group {
                            if let systemImage = SystemImageKey.from(tagTitle: tag.key) {
                                Label("\(tag.value)", systemImage: systemImage)
                            } else {
                                Text("\(tag.value)")
                            }
                        }
                        .foregroundColor(.white)
                        .font(.caption)
                    }
                    .foregroundStyle(color(from: tag.key))
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 28)
                .padding(.horizontal)
                .animation(.easeInOut, value: viewStore.todosByAmount)
                
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
                .padding(.bottom)
            }
            .onAppear {
                viewStore.send(.populate)
            }
            .sheet(
                store: store.scope(state: \.$todoForm, action: { .saveTodoForm($0) })
            ) { store in
                TodoFormView(store: store)
                    .background {
                        Color.from(tag: viewStore.todoForm?.tag).opacity(0.15)
                            .edgesIgnoringSafeArea(.bottom)
                    }
            }
        }
    }
                                     
    private func color(from tagTitle: String) -> Color {
        Color.from(tag: tag(from: tagTitle))
    }
    
    private func tag(from title: String) -> TagDTO? {
        title != "No tag" ? TagDTO(named: title) : nil
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
