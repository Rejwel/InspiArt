//
//  Persistence.swift
//  RandomArt
//
//  Created by Paweł Dera on 04/08/2021.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "RandomArt")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(artId id: String, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<SavedArt> = SavedArt.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id == \(id)")
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        save(completion: completion)
    }
    
    func getAllArts() -> [SavedArt] {
        let fetchRequest: NSFetchRequest<SavedArt> = SavedArt.fetchRequest()

        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    func deleteAllArts(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<SavedArt> = SavedArt.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        save(completion: completion)
    }
}
