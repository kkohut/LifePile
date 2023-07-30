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
    @Namespace private var animation
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    
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
                                    Label("Add todo",
                                          systemImage: "plus.circle.fill")
                                    .bold()
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.roundedRectangle)
                                .tint(.green)
                                .compositingGroup()
                            }
                            
                            ForEachStore(self.store.scope(state: \.todos, action: Todos.Action.todo(id:action:))) {
                                TodoView(store: $0)
                            }
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Image(systemName: "scalemass.fill")
                                Text(String(viewStore.totalWeight))
                                    .font(.customHeadline)
                                    .padding(4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black)
                                    }
                                
                                Text("weight")
                                    .font(.footnote)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color.gray.gradient)
                            }
                        }
                        .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                        .animation(.spring(), value: viewStore.todos.count)
                    }
                    
                }
                .padding(.bottom)
            }
            .overlay {
                if viewStore.todos.isEmpty && viewStore.filter == .todo {
                    VStack {
                        Circle()
                            .fill(Color.accentColor)
                            .padding(horizontalSizeClass == .compact ? .horizontal : .vertical, 110)
                            .shadow(color: .accentColor, radius: 8)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 64))
                                    .bold()
                                    .shadow(radius: 8)
                            }
                            .padding(.bottom, 4)
                        
                        (Text("Well done!\n")
                            .foregroundColor(.accentColor)
                            .fontWeight(.semibold)
                        +
                        Text("Nothing left to do."))
                            .font(.customTitle2)
                            .multilineTextAlignment(.center)
                    }
                    .transition(.slide.combined(with: .opacity))
                }
            }
            .animation(.spring(), value: viewStore.todos.isEmpty)
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
            .onChange(of: scenePhase) { scenePhase in
                if scenePhase == .active {
                    viewStore.send(.populate)
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
