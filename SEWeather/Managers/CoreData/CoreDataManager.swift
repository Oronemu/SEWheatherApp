//
//  CoreDataManager.swift
//  SEWeather
//
//  Created by Иван Ровков on 13.07.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // Синглтон для удобства доступа к менеджеру CoreData
    private init() {} // Приватный конструктор
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SEWeather") // Название вашей модели CoreData
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Обработка ошибки инициализации CoreData
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Обработка ошибки сохранения CoreData
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
