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
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            if let tag = viewStore.tag {
                                Text(tag.title)
                            } else {
                                Text("None")
                            }
                            
                            Image(systemName: "tag.fill")
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .frame(minWidth: 100)
                        .font(.customBody)
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.accentColor)
                        }
                        
                        tagMenu
                    }
                    
                    HStack {
                        Text(viewStore.completionStatus.rawValue)
                            .font(.customBody)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .navigationTitle("Add todo")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(role: .cancel) { viewStore.send(.cancelButtonTapped) } label: {
                        Text("Cancel")
                    },
                    trailing: Button("Add") { viewStore.send(.addButtonTapped) }
                        .bold()
                )
                .padding()
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(Material.ultraThin)
            .presentationDragIndicator(.visible)
        }
    }
    
    var tagMenu: some View {
        Menu("Choose") {
            Button(action: { }) {
                HStack {
                    Text("Housekeeping")
                    Image(systemName: "house")
                }
            }
            
            Button(action: { }) {
                HStack {
                    Text("University")
                    Image(systemName: "graduationcap")
                }
            }
            
            Button(action: { }) {
                HStack {
                    Text("Social")
                    Image(systemName: "figure.socialdance")
                }
            }
            
            Button(action: { }) {
                HStack {
                    Text("Sports")
                    Image(systemName: "dumbbell")
                }
            }
        }
        .menuOrder(.fixed)
        .menuStyle(.button)
        .menuIndicator(.visible)
    }
}

struct TodoFormView_Previews: PreviewProvider {
    static var previews: some View {
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: TagDTO(named: "University")), reducer: TodoForm()))
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo, tag: nil), reducer: TodoForm()))
    }
}
