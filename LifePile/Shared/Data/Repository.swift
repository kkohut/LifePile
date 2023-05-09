//
//  Repository.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> Result<[T], Error>
    
//    func getSingle(with id: UUID) -> Result<T, Error>
    
    func insert(newObject: T) -> Result<Bool, Error>
    
    func update(updatedObject: T, id: UUID) -> Result<Bool, Error>
    
    func delete(id: UUID) -> Result<Bool, Error>
}
