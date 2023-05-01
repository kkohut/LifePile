//
//  TodoView.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

import ComposableArchitecture
import SwiftUI

struct TodoView: View {
    let store: StoreOf<Todo>
    @FocusState var isFocused: Bool
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                if viewStore.dragState == .delete {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
                
                TextField("",
                          text: viewStore.binding(get: \.title,
                                                      send: Todo.Action.titleChanged),
                          axis: .vertical)
                .lineLimit(1...3)
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: 180)
                .font(.headline)
                .fontWeight(.semibold)
                .focused($isFocused)
                .onAppear {
                    isFocused = false
                }
                
                if isFocused {
                    Button("Save") {
                        isFocused = false
                    }
                    .bold()
                }
                
                if viewStore.dragState == .done {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(Capsule().fill(color(of: viewStore.dragState)))
            .offset(x: viewStore.offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewStore.send(.offsetChanged(newOffset: gesture.translation.width))
                    }
                    .onEnded { _ in
                        viewStore.send(.dragEnded)
                    }
            )
            .onTapGesture {
                isFocused = true
            }
            .animation(.linear, value: viewStore.offset)
            .animation(.linear(duration: 0.1), value: viewStore.dragState)
        }
    }
    
    private func color(of dragState: Todo.State.DragState) -> Color {
        switch dragState {
        case .delete:
            return .red
        case .idle:
            return .blue
        case .done:
            return .green
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room", id: UUID()),
                              reducer: Todo()))
    }
}
