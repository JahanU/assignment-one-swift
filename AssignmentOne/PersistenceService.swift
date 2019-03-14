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
                //                print("saved!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //
    //    static func getFavourite(aReport: techReport) -> Bool { // Return true if the report paper has been favourited
    //        let fetchRequest: NSFetchRequest<FavReport> = FavReport.fetchRequest()
    //
    //        do {
    //            let result = try persistentContainer.viewContext.fetch(fetchRequest)
    //
    //            for data in result { // Loop through all the fav reports from CoreData
    //                let year = data.value(forKey: "year") as? String
    //                let title = data.value(forKey: "title") as? String
    //                let id = data.value(forKey: "id") as! String
    //
    //                // If the entity matches the report given, get the favourite value
    //                if (year == aReport.year && title == aReport.title && id == aReport.id) {
    //                    return (data.value(forKey: "favourite") as? Bool)!
    //                }
    //            }
    //        }
    //        catch {
    //            print("Could not find favourite report")
    //        }
    //
    //        return false // If it could not find the report, then return false
    //    }
    
    static func getFavourite(aReport: techReport) -> Bool { // Return true if the report paper has been favourited
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavReport")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            
            // Loop through all the report entitites
            for data in result as! [NSManagedObject] {
                guard let id = data.value(forKey: "id") as? String else { return false }
                guard let year = data.value(forKey: "year") as? String else { return false }
                guard let title = data.value(forKey: "title") as? String else { return false }
                
                //  If the entity matches the report given, get the favourite value
                if (year == aReport.year && title == aReport.title && id == aReport.id) {
                    return (data.value(forKey: "favourite") as? Bool)!
                }
            }
        } catch {
            print("Failed to load!")
        }
        
        // If the entity doesn't exist, return false
        return false
    }
    
    static func unFave(aReport: techReport) {
        // find the report that matches what they passed in.
        // check if it matches core data
        // then delete it!
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavReport")
        let predicate = NSPredicate(format: "title = %@ AND year = %@ AND id = %@", aReport.title, aReport.year, aReport.id)
        fetch.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try persistentContainer.viewContext.execute(request)
       
        
        let fetchRequest: NSFetchRequest<FavReport> = FavReport.fetchRequest()
        let reports = try PersistenceService.context.fetch(fetchRequest)

        for data in reports {
            print("w")
             let id = data.value(forKey: "id") as? String
             let year = data.value(forKey: "year") as? String
             let title = data.value(forKey: "title") as? String
            
            //  If the entity matches the report given, get the favourite value
            if (year == aReport.year && title == aReport.title && id == aReport.id) {
                PersistenceService.context.delete(data as NSManagedObject)
                print("deleted \(data.title)")
//                return (data.value(forKey: "favourite") as? Bool)!
                }
            }
            
        }
        catch{}
    }
    
    static func clearCoreData() { // Loops through core data and deletes all entities
        let fetchRequest: NSFetchRequest<FavReport> = FavReport.fetchRequest()
        do {
            let reports = try PersistenceService.context.fetch(fetchRequest)
            for obj in reports {
                PersistenceService.context.delete(obj as NSManagedObject)
            }
        }
        catch {}
    }
    
    
}



