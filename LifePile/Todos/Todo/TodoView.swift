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
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                if viewStore.dragState == .delete {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
                
                Text(viewStore.title)
                //                    .frame(minWidth: 0, maxWidth: 180)
                    .font(.customHeadline)
                    .fontWeight(.semibold)
                
                if viewStore.dragState == .complete {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }
            .disabled(viewStore.completionStatus == .done)
            .foregroundColor(.white)
            .overlay(alignment: .topLeading) {
                if viewStore.dragState == .delete {
                    Text("delete")
                        .font(.customBody)
                        .foregroundStyle(color(of: viewStore.dragState))
                        .fixedSize()
                        .offset(y: -30)
                }
            }
            .overlay(alignment: .topTrailing) {
                if viewStore.dragState == .complete {
                    Text("done")
                        .font(.customBody)
                        .foregroundStyle(color(of: viewStore.dragState))
                        .fixedSize()
                        .offset(y: -30)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(viewStore.dragState == .idle ? Color.from(tag: viewStore.tag) :
                            color(of: viewStore.dragState).opacity(viewStore.completionStatus != .done ? 1 : 0.5))
            }
            .padding(.horizontal, 50)
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
                viewStore.send(.editTodo)
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
            return .accentColor
        case .complete:
            return .green
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: Store(initialState: Todo.State(title: "Clean room", completionStatus: .todo, id: UUID(), tag: TagDTO(named: "University")),
                              reducer: Todo()))
    }
}
