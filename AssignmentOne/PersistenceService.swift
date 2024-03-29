//
//  PersistenceService.swift
//  AssignmentOne
//
//  Created by Jahan on 10/03/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext // This container stores all the things we would like to save
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AssignmentOne")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext // As this stores everything the user wants to save, we then save this into our "Database/CoreData"
        if context.hasChanges {
            do {
                try context.save()
                // print("saved!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func getFavourite(aReport: techReport) -> Bool { // Return true if the report paper has been favourited
        let fetchRequest: NSFetchRequest<FavReport> = FavReport.fetchRequest()
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result { // Loop through all the fav reports from CoreData
                let year = data.value(forKey: "year") as? String
                let title = data.value(forKey: "title") as? String
                let id = data.value(forKey: "id") as! String
                
                // If the entity matches the report given, get the favourite value.
                if (year == aReport.year && title == aReport.title && id == aReport.id) {
                    return (data.value(forKey: "favourite") as? Bool)!
                }
            }
        }
        catch {
            print("Could not find favourite report")
        }
        
        return false // If it could not find the report, then return false
    }
    
    static func unFave(aReport: techReport) {
        // find the report that matches what they passed in.
        // check if it matches core data, then delete it
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavReport")
        // Finds a match given the report
        let predicate = NSPredicate(format: "title = %@ AND year = %@ AND id = %@", aReport.title, aReport.year, aReport.id) // Attempts to find a match
        fetch.predicate = predicate // Fetches the match result
        let request = NSBatchDeleteRequest(fetchRequest: fetch) // Request to delete fav from core data
        do {
            try persistentContainer.viewContext.execute(request) // Execute the delete action into the coredata container
        }
        catch {
            print("Cannot find report to delete")
        }
    }
    
    static func clearCoreData() { // Loops through core data and deletes all entities
        let fetchRequest: NSFetchRequest<FavReport> = FavReport.fetchRequest()
        do {
            let reports = try PersistenceService.context.fetch(fetchRequest)
            for obj in reports {
                PersistenceService.context.delete(obj as NSManagedObject)
            }
        }
        catch {
            print("Cannot clear core data")
        }
    }
    
    
}



