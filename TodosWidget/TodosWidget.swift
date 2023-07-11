//
//  TodosWidget.swift
//  TodosWidget
//
//  Created by Kevin Kohut on 11.07.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> Void) {
        let date = Date()
        let entry = TodoEntry(
            date: Date.now,
            todoData: fetchTodoData()
        )
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
        
        completion(Timeline(entries: [entry], policy: .after(nextUpdateDate)))
    }
    
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date.now, todoData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> Void) {
        let entry = TodoEntry(date: Date.now, todoData: (count: 7, totalWeight: 54))
        completion(entry)
    }
    
    func fetchTodoData() -> (count: Int, totalWeight: Int)? {
        if let userDefaults = UserDefaults(suiteName: "group.lifepile") {
            let count = userDefaults.integer(forKey: "todoCount")
            let totalWeight = userDefaults.integer(forKey: "todoTotalWeight")
            return (count, totalWeight)
        } else {
            return nil
        }
    }
}

struct TodoEntry: TimelineEntry {
    var date: Date
    var todoData: (count: Int, totalWeight: Int)?
}

struct TodosWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "de.kkohut.lifepile.todos",
            provider: Provider()
        ) { entry in
            TodosWidgetView(todoData: entry.todoData)
        }
        .configurationDisplayName("Todos")
        .description("Shows information about your current todos")
        .supportedFamilies([.systemSmall])
    }
}

struct TodosWidgetView: View {
    let todoData: (count: Int, totalWeight: Int)?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let todoData {
                Text("LifePile")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(todoData.count))
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                        .bold()
                    
                    Text("Todos").foregroundColor(.secondary)
                        .font(.caption)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(todoData.totalWeight))
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                        .bold()
                    
                    Text("total weight").foregroundColor(.secondary)
                        .font(.caption)
                }
            } else {
                Text("Tap to load data")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("WidgetBackground").ignoresSafeArea())
        .ignoresSafeArea()
    }
}
