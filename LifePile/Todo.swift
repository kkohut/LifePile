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
        var title: String
        var offset = 0.0
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case resetOffset
        case removeTodo
        case titleChanged(newTitle: String)
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
        case .titleChanged(let newTitle):
            state.title = newTitle
            return .none
        }
    }
}

struct TodoView: View {
    let store: StoreOf<Todo>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TextField("", text: viewStore.binding(get: \.title,
                                                  send: Todo.Action.titleChanged))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .fixedSize()
                .background(Capsule().fill(Color.blue))
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
                .animation(.spring(), value: viewStore.offset)
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room"),
                              reducer: Todo()))
    }
}
