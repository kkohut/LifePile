//
//  CreateTodoView.swift
//  LifePile
//
//  Created by Kevin Kohut on 04.06.23.
//

import ComposableArchitecture
import SwiftUI

struct CreateTodoView: View {
    let store: StoreOf<Todo>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text(viewStore.title)
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
                .buttonBorderShape(.roundedRectangle(radius: 16))
            }
            .padding()
        }
    }
}

struct CreateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoView(store: Store(initialState: Todo.State(title: "New Todo", completionStatus: .todo, id: UUID()), reducer: Todo()))
        CreateTodoView(store: Store(initialState: Todo.State(title: "New Todo", completionStatus: .todo, id: UUID()),
                                    reducer: Todo()))
    }
}
