//
//  LifePileApp.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import SwiftUI
import ComposableArchitecture

@main
struct LifePileApp: App {
    var body: some Scene {
        WindowGroup {
            TodosView(
                store: Store(
                    initialState: Todos.State(todos: [], filter: .todo),
                    reducer: Todos()
                )
            )
            .background {
                Color.Custom.background
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
