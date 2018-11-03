//
//  NewTaskViewController.swift
//  YourApp
//
//  Created by honza on 02/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var textFieldInput: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        let newItem = Task(context: self.context)
        
        newItem.done = false
        newItem.title = textFieldInput.text
        
        saveItems()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func changeColor(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 1:
            print("red")
        case 2:
            print("gree")
        case 3:
            print("blue")
        default:
            print("Unknown language")
            return
        }
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
