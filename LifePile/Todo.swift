//
//  Todo.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import ComposableArchitecture
import SwiftUI

struct Todo: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        let title: String
        var offset = 0.0
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case resetOffset
        case removeTodo
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            state.offset = newOffset
            return .none
        case .resetOffset:
            state.offset = 0
            return .none
        case .removeTodo:
            return .none
        }
    }
}

struct TodoView: View {
    let store: StoreOf<Todo>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(viewStore.title)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Capsule().fill(Color.blue))
                .frame(maxWidth: .infinity)
                .offset(x: viewStore.offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            viewStore.send(.offsetChanged(newOffset: gesture.translation.width))
                        }
                        .onEnded { _ in
                            viewStore.send(abs(viewStore.offset) > 100 ? .removeTodo : .resetOffset)
                        }
                )
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room"),
                              reducer: Todo()))
    }
}
