//
//  Persistence.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 23/05/21.

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "XKCD")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Stops Saving Duplicates
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Saving error: \(error.localizedDescription)")
            }
        }
    }
}
