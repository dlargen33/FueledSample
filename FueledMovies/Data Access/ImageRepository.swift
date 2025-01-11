//
//  ImageRepository.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/10/25.
//

import Foundation
import CoreData

class ImageRepository {
    
    static let shared = ImageRepository()
    
    private var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func newBackgroundContext()-> NSManagedObjectContext {
        PersistenceController.shared.container.newBackgroundContext()
    }
    
    func getImageData(movieId: Int, size: String) -> Data? {
        let context = newBackgroundContext()
        return context.performAndWait { () -> Data? in
            do {
                let fetchRequest: NSFetchRequest<ImageDataEntity> = ImageDataEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "movieId == %d AND imageSize == %@", Int64(movieId), size)
                fetchRequest.fetchLimit = 1
                return try context.fetch(fetchRequest).first?.imageData
            }
            catch {
                print("Error while fetching image data \(error)")
                return nil
            }
        }
    }
    
    @discardableResult
    func addImageData(movieId: Int,
                      size: String,
                      data: Data) -> Bool {
        let context = newBackgroundContext()
        return context.performAndWait{
            do {
                let fetchRequest: NSFetchRequest<ImageDataEntity> = ImageDataEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "movieId == %d AND imageSize == %@", Int64(movieId), size)

                if let existingEntity = try context.fetch(fetchRequest).first {
                    existingEntity.imageData = data
                }
                else {
                    let imageDataEntity = ImageDataEntity(context: context)
                    imageDataEntity.movieId = Int64(movieId)
                    imageDataEntity.imageSize = size
                    imageDataEntity.imageData = data
                }
                try context.save()
                return true
            }
            catch {
                print("Error while adding image data \(error)")
                return false
            }
        }
    }
}
