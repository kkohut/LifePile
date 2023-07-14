//
//  Storage.swift
//  LifePile
//
//  Created by Kevin Kohut on 06.05.23.
//

import CoreData
import Foundation
import OSLog

public class Storage {
    let container: NSPersistentCloudKitContainer

    static let shared = Storage()

    static var preview: Storage = {
        let controller = Storage(inMemory: true)
        let viewContext = controller.container.viewContext

        do {
            try viewContext.save()
        } catch {
            print("Could not save previews")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    private init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "LifePile")


        #if DEBUG
        do {
            try container.initializeCloudKitSchema(options: [])
        } catch {
            Logger().error("Initializing CloudKit schema failed")
        }
        #endif
        
        if inMemory {
            self.container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Cloudkit store failed with error: \(error)")
            }
            print("Core data loaded: \(description)")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
