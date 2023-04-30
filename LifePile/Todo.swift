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
        var dragState = DragState.idle {
            willSet {
                if dragState != newValue {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
        
        enum DragState {
            case idle
            case done
            case delete
        }
    }
    
    enum Action: Equatable {
        case offsetChanged(newOffset: Double)
        case draggedUnderThreshold
        case draggedToDeletion
        case draggedToCompletion
        //        case draggedOverThreshold
        //        case dragEnded
        case titleChanged(newTitle: String)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .offsetChanged(let newOffset):
            state.offset = newOffset
            switch state.offset {
                case -(Double.infinity) ..< -50.0:
                state.dragState = .delete
            case -50.0 ..< 50.0:
                state.dragState = .idle
            case 50.0 ..< Double.infinity:
                state.dragState = .done
            default:
                fatalError("Switch over double is not exhaustive")
            }
            //            if !state.aboutToBeDone && newOffset >= 50 {
            //                state.aboutToBeDone = true
            //                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            //            } else if newOffset < 50 {
            //                state.aboutToBeDone = false
            //            }
            return .none
        case .draggedUnderThreshold:
            state.offset = 0
            return .none
        case .draggedToDeletion:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            return .none
        case .draggedToCompletion:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            return .none
            //        case .dragEnded:
            //            switch state.dragState {
            //            case .idle:
            //                state.offset = 0
            //            case .done:
            //
            //            case .delete:
            //                <#code#>
            //            }
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
            var color: Color {
                switch viewStore.dragState {
                case .delete:
                    return .red
                case .idle:
                    return .blue
                case .done:
                    return .green
                }
            }
            
            HStack {
                if viewStore.dragState == .delete {
                    Image(systemName: "x.circle")
                }
                
                TextField("", text: viewStore.binding(get: \.title,
                                                      send: Todo.Action.titleChanged))
                
                if viewStore.dragState == .done {
                    Image(systemName: "checkmark.circle")
                }
            }
            .frame(height: 16)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .fixedSize()
            .background(Capsule().fill(color))
            .offset(x: viewStore.offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewStore.send(.offsetChanged(newOffset: gesture.translation.width))
                    }
                    .onEnded { _ in
                        switch viewStore.dragState {
                        case .delete:
                            viewStore.send(.draggedToDeletion)
                        case .idle:
                            viewStore.send(.draggedUnderThreshold)
                        case .done:
                            viewStore.send(.draggedToCompletion)
                        }
                    }
            )
            .animation(.linear, value: viewStore.offset)
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room"),
                              reducer: Todo()))
    }
}
