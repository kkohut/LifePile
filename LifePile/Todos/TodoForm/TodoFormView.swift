//
//  CreateTodoView.swift
//  LifePile
//
//  Created by Kevin Kohut on 04.06.23.
//

import ComposableArchitecture
import SwiftUI

struct TodoFormView: View {
    let store: StoreOf<TodoForm>
    @Namespace private var animation
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    HStack {
                        TextField("Title",
                                  text: viewStore.binding(get: \.title,
                                                          send: TodoForm.Action.titleChanged))
                        .font(.customTitle2)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(viewStore.completionStatus.rawValue)
                            .font(.customBody)
                        
                        Spacer()
                        
                        Menu {
                            ForEach(viewStore.defaultTags, id: \.title) { tag in
                                Button(action: { viewStore.send(.tagChanged(tag: tag)) }) {
                                    Label(tag.title,
                                          systemImage: SystemImageKey.from(tagTitle: tag.title))
                                }
                            }
                            
                            Button(action: { viewStore.send(.tagChanged(tag: nil)) }) {
                                Label("None", systemImage: "x.circle")
                            }
                        } label: {
                            Label(viewStore.tag?.title ?? "None",
                                  systemImage: SystemImageKey.from(tagTitle: viewStore.tag?.title))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        }
                        .font(.customBody)
                        .buttonStyle(.borderedProminent)
                        .menuOrder(.fixed)
                        .menuStyle(.button)
                        .menuIndicator(.visible)
                        .labelStyle(.titleAndIcon)
                        .tint(.from(tag: viewStore.tag))
                        .animation(.spring(), value: viewStore.tag)
                    }
                }
                .navigationTitle("Add todo")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(role: .cancel) { viewStore.send(.cancelButtonTapped) } label: {
                        Text("Cancel")
                    },
                    trailing: Button("Add") { viewStore.send(.addButtonTapped) }
                        .bold()
                )
                #endif
                .padding()
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(Material.ultraThin)
            .presentationDragIndicator(.visible)
        }
    }
}

struct TodoFormView_Previews: PreviewProvider {
    static var previews: some View {
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: TagDTO(named: "University")), reducer: TodoForm()))
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: nil), reducer: TodoForm()))
    }
}
