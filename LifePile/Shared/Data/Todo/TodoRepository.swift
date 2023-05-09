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
    
//    func getSingle(with id: UUID) -> Result<TodoDTO, Error> {
//        <#code#>
//    }
//    
    func insert(newObject: TodoDTO) -> Result<Bool, Error> {
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: "TodoMO", into: managedObjectContext) as? TodoMO else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        managedObject.id = newObject.id
        managedObject.title = newObject.title
        try! managedObjectContext.save()
        return .success(true)
    }
    
    func update(updatedObject: TodoDTO, id: UUID) -> Result<Bool, Error> {
        let fetchRequest = TodoMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest).first!
            fetchResult.title = updatedObject.title
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

enum CoreDataError: Error {
    case invalidManagedObjectType
}
