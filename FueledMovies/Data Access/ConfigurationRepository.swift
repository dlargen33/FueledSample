//
//  ConfigurationRepository.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/8/25.
//

import Foundation
import CoreData

/*
 ConfigurationRepository provides access to Configuration Data stored in Core Data.
*/

class ConfigurationRepository {
    static let shared = ConfigurationRepository()
    
    private var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func newBackgroundContext()-> NSManagedObjectContext {
        PersistenceController.shared.container.newBackgroundContext()
    }
    
    func getConfiguration() -> Configuration? {
        let context = newBackgroundContext()
        return context.performAndWait { () -> Configuration? in
            do {
                let fetchRequest = NSFetchRequest<ConfigurationEntity>(entityName: "ConfigurationEntity")
                fetchRequest.fetchLimit = 1
                guard let configEntity = try context.fetch(fetchRequest).first,
                      let imageEntity = configEntity.images else { return nil }
                
                let images = Images(baseUrl: imageEntity.baseUrl ?? "",
                                    secureBaseUrl: imageEntity.secureBaseUrl ?? "",
                                    backdropSizes: imageEntity.backdropSizes?.toArray() ?? [],
                                    logoSizes: imageEntity.logoSizes?.toArray() ?? [],
                                    posterSizes: imageEntity.posterSizes?.toArray() ?? [],
                                    profileSizes: imageEntity.profileSizes?.toArray() ?? [],
                                    stillSizes: imageEntity.stillSizes?.toArray() ?? [])
                
                let configuration = Configuration(changeKeys: configEntity.changeKeys?.toArray() ?? [],
                                                  images: images)
                return configuration
            }
            catch {
                print("Error while fetching configuration \(error)")
                return nil
            }
        }
    }
    
    @discardableResult
    func add(configuration: Configuration) -> Bool {
        let context = newBackgroundContext()
        return context.performAndWait{
            do {
                let fetchRequest = NSFetchRequest<ConfigurationEntity>(entityName: "ConfigurationEntity")
                fetchRequest.fetchLimit = 1
                if let existingConfig = try context.fetch(fetchRequest).first {
                    context.delete(existingConfig)
                }
            
                let configurationEntity = ConfigurationEntity(context: context)
                configurationEntity.changeKeys = configuration.changeKeys.toArray()
            
                let imagesEntity = ImageEntity(context: context)
                imagesEntity.baseUrl = configuration.images.baseUrl
                imagesEntity.secureBaseUrl = configuration.images.secureBaseUrl
                imagesEntity.backdropSizes = configuration.images.backdropSizes.toArray()
                imagesEntity.logoSizes = configuration.images.logoSizes.toArray()
                imagesEntity.posterSizes = configuration.images.posterSizes.toArray()
                imagesEntity.profileSizes = configuration.images.profileSizes.toArray()
                imagesEntity.stillSizes = configuration.images.stillSizes.toArray()
                configurationEntity.images = imagesEntity
            
                try context.save()
                return true
            } catch {
                print("Error while adding configuration: \(error.localizedDescription)")
                return false
            }
        }
    }
    
    @discardableResult
    func delete() -> Bool {
        let context = newBackgroundContext()
        return context.performAndWait {
            let fetchRequest = NSFetchRequest<ConfigurationEntity>(entityName: "ConfigurationEntity")
            fetchRequest.fetchLimit = 1
            do {
                guard let configEntity = try context.fetch(fetchRequest).first  else {
                    return true
                }
                
                context.delete(configEntity)
                try context.save()
                return true
            } catch {
                print("Error while deleting configuration: \(error.localizedDescription)")
                return false
            }
        }
    }
}

extension Array where Element == String {
    func toArray() -> NSArray {
        return self as NSArray
    }
}

extension NSArray {
    func toArray<T>() -> [T] {
        return self as? [T] ?? []
    }
}
