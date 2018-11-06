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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveItems() {
        do {
            try context.save()
            print("Saving to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
    }
    
    func getTasks() -> [Task] {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        var itemArray =  [Task]()
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data \(error)")
        }
        return itemArray
    }
    
    func getCategories() -> [Category] {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        var categoryArray = [Category]()
        do {
            categoryArray =  try context.fetch(request)
        }
        catch {
            print("Error fetching data \(error)")
        }
        return categoryArray
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
    }
}
