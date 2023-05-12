//
//  CoreDataClient.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import CoreData
import Dependencies
import Foundation

struct CoreDataClient: DependencyKey {
    static var liveValue: CoreDataClient {
        return Self(
            storage: Storage.shared,
            todoRepository: TodoRepository(managedObjectContext: Storage.shared.container.viewContext) //
        )
    }
    
    let storage: Storage
    let todoRepository: TodoRepository
}

extension DependencyValues {
    var coreData: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}
