//
//  TodoRepository.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import CoreData
import Foundation

struct TodoRepository: Repository {
    typealias T = TodoDTO
    
    var managedObjectContext: NSManagedObjectContext

    func getAll() -> Result<[TodoDTO], Error> {
        do {
            let fetchResults = try managedObjectContext.fetch(TodoMO.fetchRequest())
            return .success(fetchResults.map { $0.dto })
        } catch {
            return .failure(error)
        }
    }
    
    func insert(newObject: TodoDTO) -> Result<TodoDTO, Error> {
        guard let todoMO = NSEntityDescription.insertNewObject(forEntityName: "TodoMO", into: managedObjectContext) as? TodoMO else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        todoMO.id = newObject.id
        todoMO.title = newObject.title
        todoMO.completionStatus = newObject.completionStatus.rawValue
        try! managedObjectContext.save()
        return .success(todoMO.dto)
    }
    
    func update(to updatedObject: TodoDTO, id: UUID) -> Result<Bool, Error> {
        let fetchRequest = TodoMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let fetchedTodoMO = try managedObjectContext.fetch(fetchRequest).first!
            fetchedTodoMO.title = updatedObject.title
            fetchedTodoMO.completionStatus = updatedObject.completionStatus.rawValue
            try! managedObjectContext.save()
            return.success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(id: UUID) -> Result<Bool, Error> {
        let fetchRequest = TodoMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest).first!
            managedObjectContext.delete(fetchResult)
            try! managedObjectContext.save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}

