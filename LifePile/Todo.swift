//
//  Todo.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import ComposableArchitecture
import SwiftUI
import AudioToolbox

struct Todo: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        var title: String
        var offset = 0.0
        var aboutToBeDone = false
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case draggedUnderThreshold
        case draggedOverThreshold
        case titleChanged(newTitle: String)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            state.offset = newOffset
            if !state.aboutToBeDone && newOffset >= 50 {
                state.aboutToBeDone = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } else if newOffset < 50 {
                state.aboutToBeDone = false
            }
            return .none
        case .draggedUnderThreshold:
            state.offset = 0
            return .none
        case .draggedOverThreshold:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
            HStack {
                if viewStore.aboutToBeDone {
                    Image(systemName: "checkmark")
                }
                
                TextField("", text: viewStore.binding(get: \.title,
                                                      send: Todo.Action.titleChanged))
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .fixedSize()
            .background(Capsule().fill(viewStore.aboutToBeDone ? Color.green : Color.blue))
            .offset(x: viewStore.offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewStore.send(.offsetChanged(newOffset: gesture.translation.width))
                    }
                    .onEnded { _ in
                        let dragThreshold = 100.0
                        viewStore.send(viewStore.aboutToBeDone ? .draggedOverThreshold : .draggedUnderThreshold)
                    }
            )
            .transition(.slide.combined(with: .opacity))
            .animation(.linear, value: viewStore.offset	)
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room"),
                              reducer: Todo()))
    }
}
