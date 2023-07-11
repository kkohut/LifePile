//
//  TodosWidget.swift
//  LifePile
//
//  Created by Kevin Kohut on 11.07.23.
//

import Foundation
import WidgetKit
import SwiftUI
import Dependencies

//@main
//struct TodosWidget: Widget {
//    var body: some WidgetConfiguration {
//        StaticConfiguration(
//            kind: "de.kkohut.lifepile.todos",
//            provider: TodosProvider()
//        ) { entry in
//            TodosWidgetView(todoCount: entry.todoCount)
//        }
//        .configurationDisplayName("Todos")
//        .description("Shows you information about your current todos")
//        .supportedFamilies([.systemSmall])
//    }
//}
//
//struct TodosProvider: TimelineProvider {
//    @Dependency(\.coreData) var coreData
//    
//    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> Void) {
//        let date = Date()
//        let entry = TodoEntry(
//            date: Date.now,
//            todoCount: try! coreData.todoRepository.getAll()
//                .get()
//                .filter { $0.completionStatus == .todo }
//                .count
//        )
//        
//        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
//        
//        completion(Timeline(entries: [entry], policy: .after(nextUpdateDate)))
//    }
//    
//    func placeholder(in context: Context) -> TodoEntry {
//        TodoEntry(date: Date.now, todoCount: 0)
//    }
//    
//    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> Void) {
//        let entry = TodoEntry(date: Date.now, todoCount: 0)
//        completion(entry)
//    }
//}
//
//struct TodoEntry: TimelineEntry {
//    var date: Date
//    var todoCount: Int
//}
//
//struct TodosWidgetView: View {
//    let todoCount: Int
//    
//    var body: some View {
//        Text(String(todoCount))
//    }
//}
