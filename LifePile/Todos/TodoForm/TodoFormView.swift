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
            VStack {
                HStack {
                    TextField("Title",
                              text: viewStore.binding(get: \.title,
                                                      send: TodoForm.Action.titleChanged))
                    .font(.customLargeTitle)
                    
                    Spacer()
                }
                
                HStack {
                    Text(viewStore.completionStatus.rawValue)
                        .font(.customBody)
                    
                    Spacer()
                }
                
                Spacer()
                
                Button("Save Todo") {
                    viewStore.send(.saveButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

struct CreateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo), reducer: TodoForm()))
        TodoFormView(store: Store(initialState: TodoForm.State(id: UUID(), title: "New Todo", completionStatus: .todo), reducer: TodoForm()))
    }
}
