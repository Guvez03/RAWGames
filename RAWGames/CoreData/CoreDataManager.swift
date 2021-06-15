//
//  CoreDataManager.swift
//  AppCentProject
//
//  Created by ahmet on 11.06.2021.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "FavoriteDataModel")
        persistentContainer.loadPersistentStores { (_, error) in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    var moc: NSManagedObjectContext {
        CoreDataManager.persistentContainer.viewContext
    }
    
    func getFavorite(_ id: Int)-> FavoriteGame?{
        do{
            let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
            if let result = try? moc.fetch(fetchRequest) {
                for object in result {
                    return object
                }
            }
            
        }
        return nil
    }
    func getGameItem(_ id: Int)-> GameList?{
        do{
            let fetchRequest: NSFetchRequest<GameList> = GameList.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
            if let result = try? moc.fetch(fetchRequest) {
                for object in result {
                    return object
                }
            }
            
        }
        return nil
    }
    public func delete(_ id: Int) {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        if let result = try? moc.fetch(fetchRequest) {
            for object in result {
                moc.delete(object)
            }
        }
        
        do {
            try moc.save()
        } catch {
            
        }
    }
    func saveFavorite(name: String,released: String,rating: Double,attDescription:String,background_image: String,isSelected:Bool,id:Int){
        
        let event = FavoriteGame(context: moc)
        event.setValue(name, forKey: "name")
        event.setValue(released, forKey: "released")
        event.setValue(rating, forKey: "rating")
        event.setValue(background_image, forKey: "background_image")
        event.setValue(isSelected, forKey: "isSelected")
        event.setValue(id, forKey: "id")
        event.setValue(attDescription, forKey: "attDescription")
        
        do{
            try moc.save()
        }catch{
            print(error)
        }
        
    }
    func saveGameList(name: String,released: String,rating: Double,background_image: String,id:Int){
        
        let event = GameList(context: moc)
        event.setValue(name, forKey: "name")
        event.setValue(id, forKey: "id")
        event.setValue(released, forKey: "released")
        event.setValue(rating, forKey: "rating")
        event.setValue(background_image, forKey: "background_image")
        do{
            try moc.save()
        }catch{
            print(error)
        }
        
    }
    public func updateFavorite(event: FavoriteGame, name: String,released: String,rating: Double,background_image: String,isSelected:Bool,attDescription:String,id:Int) {
        
        event.setValue(name, forKey: "name")
        event.setValue(released, forKey: "released")
        event.setValue(rating, forKey: "rating")
        event.setValue(background_image, forKey: "background_image")
        event.setValue(isSelected, forKey: "isSelected")
        event.setValue(id, forKey: "id")
        event.setValue(attDescription, forKey: "attDescription")
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func fetchFavorites() -> [FavoriteGame] {
        do{
            let fetchRequest = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
            let events = try moc.fetch(fetchRequest)
            return events
        }catch{
            print(error)
            return []
        }
    }
    func fetchGameList() -> [GameList]? {
        do{
            let fetchRequest = NSFetchRequest<GameList>(entityName: "GameList")
            let events = try moc.fetch(fetchRequest)
            return events
        }catch{
            print(error)
            return []
        }
    }
    func deleteGameList() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GameList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try CoreDataManager.persistentContainer.viewContext.execute(deleteRequest)
        } catch _ as NSError {
            
        }
        
    }
    
}
