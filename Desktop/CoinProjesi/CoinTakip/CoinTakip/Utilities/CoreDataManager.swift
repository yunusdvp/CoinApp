//
//  CoreDataManager.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 8.05.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoinTakip")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func isFavorite(coinName: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteCoins> = FavoriteCoins.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", coinName)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error fetching data: \(error)")
            return false
        }
    }
    
    func addToFavorites(coinName: String) {
        let favorite = FavoriteCoins(context: context)
        favorite.name = coinName
        saveContext()
    }
    func fetchFavoriteCoinNames() -> [String] {
        let fetchRequest: NSFetchRequest<FavoriteCoins> = FavoriteCoins.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.name! } 
        } catch {
            print("Error fetching favorite coins: \(error)")
            return []
        }
    }

    func removeFromFavorites(coinName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteCoins.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", coinName)
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
