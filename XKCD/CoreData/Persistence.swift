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
                print("CoreData saving error: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: false)
        let viewContext = result.container.viewContext
        
        // ** Prepare all sample data for previews here ** //
        let item = Favorite(context: viewContext)
        item.title = "Title"
        item.alt = "Alt"
        item.transcript = "Transcript"
        item.image = Data()
        item.num = 1
        
        do {
            try viewContext.save()
        } catch {
            // handle error for production
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
}
