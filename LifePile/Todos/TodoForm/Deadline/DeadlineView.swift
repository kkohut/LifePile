//
//  DeadlineView.swift
//  LifePile
//
//  Created by Kevin Kohut on 07.07.23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct DeadlineView: View {
//    struct ViewState: Equatable {
//        @BindingViewState var date: Date
//    }
    
    let store: StoreOf<Deadline>
    @State private var date = Date()
    
    var body: some View {
//        WithViewStore(self.store, observe: { ViewState(date: $0.$date) }) { viewStore in
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
//                DatePicker("deadline", selection: viewStore.binding(\.$date), displayedComponents: [.date])
//                DatePicker("deadline", selection: viewStore.bin, displayedComponents: [.date])
                
                DatePicker("deadline", selection: $date, displayedComponents: [.date])
//                    .onAppear {
//                        date = viewStore.date
//                    }
                    .onChange(of: date, perform: {
                        viewStore.send(.dateChanged(date: $0))
                    })
                
                
//                DatePicker(selection: viewStore.binding(get: \.date,
//                                                        send: Deadline.Action.dateChanged),
//                           displayedComponents: [.date]) {
//                    Label("Deadline", systemImage: "calendar")
//                        .foregroundColor(.accentColor)
//                        .fontWeight(.semibold)
//                }
                
//                TextField("Hello", text: viewStore.$text)
                
//                DatePicker(selection: viewStore.$date,
//                           displayedComponents: [.date]) {
//                    Label("Deadline", systemImage: "calendar")
//                        .foregroundColor(.accentColor)
//                        .fontWeight(.semibold)
//                }
                
//                DatePicker("deadline", selection: viewStore.binding(get: \.date,
//                                                        send: Deadline.Action.dateChanged),
//                           displayedComponents: [.date])
                
//                DatePicker("deadline", selection: viewStore.$date,
//                           displayedComponents: [.date])
                
                
//                Button(action: { viewStore.send(.deleteDeadlineButtonTapped) }) {
//                    Label("Delete", systemImage: "xmark.circle")
//                        .foregroundColor(.red)
//                        .labelStyle(.iconOnly)
//                }
            }
            .font(.customBody)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Material.ultraThin)
            }
        }
    }
}

//struct DeadlineView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeadlineView(store: .init(initialState: .init(date: Date()), reducer: Deadline()))
//    }
//}
