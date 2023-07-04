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
                    HStack(alignment: .top) {
                        TextField("Title",
                                  text: viewStore.binding(get: \.title,
                                                          send: TodoForm.Action.titleChanged),
                                  axis: .vertical)
                        .lineLimit(3)
                        .font(.customTitle2)
                        .padding(6)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Material.ultraThin)
//                                .shadow(radius: 4, x: 2, y: 2)
                        }
                        
                        Spacer()
                        
                        Group {
                            if viewStore.completionStatus == .done {
                                Button(action: { viewStore.send(.markAsToDo) }) {
                                    Label("Done", systemImage: "checkmark.circle")
                                }
                            } else {
                                Button(action: { viewStore.send(.markAsDone) }) {
                                    Label("To Do", systemImage: "tray")
                                }
                            }
                        }
                        .font(.customBody)
                        .tint(viewStore.completionStatus == .todo ? .orange : .green)
                        .buttonStyle(.borderedProminent)
                        .animation(.bouncy, value: viewStore.completionStatus)
                    }
                    
                    Spacer()
                    
                    VStack {
                            HStack(alignment: .lastTextBaseline) {
                                Label("Weight", systemImage: "scalemass.fill")
                                
                                Spacer()
                                
                                Text(String(Int(viewStore.weight)))
                                    .bold()
                                    .font(.customTitle3)
                            }
                            .font(.customBody)
                            
                            Slider(
                                value: viewStore.binding(get: \.weight,
                                                         send: TodoForm.Action.weightChanged),
                                in: 0...Double(10)
                            )
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Material.ultraThin)
//                            .shadow(radius: 4, x: 2, y: 2)
                    }
                    .padding(.bottom)
                    
                    HStack {
                        if viewStore.operation == .edit {
                            Button(action: { viewStore.send(.delete) }) {
                                Label("Delete", systemImage: "x.circle")
                            }
                            .tint(.red)
                            .buttonStyle(.bordered)
                        }
                        
                        Spacer()
                        
                        Menu {
                            ForEach(viewStore.defaultTags, id: \.title) { tag in
                                Button(action: { viewStore.send(.tagChanged(tag: tag)) }) {
                                    Label(tag.title,
                                          systemImage: SystemImageKey.from(tagTitle: tag.title) ?? "tag.fill")
                                }
                            }
                            
                            Button(action: { viewStore.send(.tagChanged(tag: nil)) }) {
                                Label("None", systemImage: "x.circle")
                            }
                        } label: {
                            Label(viewStore.tag?.title ?? "None",
                                  systemImage: SystemImageKey.from(tagTitle: viewStore.tag?.title) ?? "tag.fill")
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
                .navigationTitle(viewStore.operation == .add ? "Add todo": "Edit Todo")
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(role: .cancel) { viewStore.send(.cancelButtonTapped) } label: {
                        Text("Cancel")
                    },
                    trailing: Button("Save") { viewStore.send(.saveButtonTapped) }
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
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: TagDTO(named: "University"), weight: 7, operation: .add), reducer: TodoForm()))
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: nil, weight: 10, operation: .edit), reducer: TodoForm()))
    }
}
