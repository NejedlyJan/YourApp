//
//  SettingsViewController.swift
//  YourApp
//
//  Created by honza on 03/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var newCategoryInputOutlet: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newItem = Category(context: self.context)
        newItem.name = newCategoryInputOutlet.text
        saveItems()
    }
    func saveItems() {
        do {
            try context.save()
            print("Saving to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
    }
}
