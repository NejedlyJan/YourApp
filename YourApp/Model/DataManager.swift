//
//  DataManager.swift
//  YourApp
//
//  Created by honza on 06/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import CoreData
import UIKit

class DataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
    }

    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    func getItem<T:NSManagedObject>(_ type: T.Type) -> [T] {
        let request : NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        var itemArray = [T]()
        do {
            itemArray =  try context.fetch(request)
        }
        catch {
            print("Error fetching data \(error)")
        }
        return itemArray
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
    }
}
