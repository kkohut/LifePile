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
            VStack(alignment: .leading) {
                HStack {
                    Text(viewStore.title)
                        .font(.largeTitle)
                    
                    Spacer()
                }
                
                Text(viewStore.completionStatus.rawValue)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct CreateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoView(store: Store(initialState: Todo.State(title: "New Todo", completionStatus: .todo, id: UUID()),
                                    reducer: Todo()))
    }
}
