//
//  Persistence.swift
//  ToDoList
//
//  Created by IKAKOOO on 18.01.23.
//

import CoreData

struct PersistenceController {
    // MARK: - PERSISTENT CONTROLER
    static let shared = PersistenceController()

    // MARK: - PERSISTENT CONTAINER
    let container: NSPersistentContainer
    
    // for test pull request commit
    // MARK: - INITIALIZATION (load the persistent store) 
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - PREVIEW
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.task = "Sample Task \(i)"
            newItem.timestamp = Date()
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
