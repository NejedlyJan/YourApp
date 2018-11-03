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
    var selectedColorButtonTag = 1
    
    override func viewDidLoad() {
        selectButton()
    }
    
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        let newItem = Task(context: self.context)
        
        newItem.done = false
        newItem.categoryColor = Int32(selectedColorButtonTag)
        newItem.title = textFieldInput.text
        
        saveItems()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeColor(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        selectedColorButtonTag = button.tag
        selectButton()
    }
    
    func selectButton() {
        for button in self.view.subviews {
            if button.tag == selectedColorButtonTag {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.blue.cgColor
            }
            else {
                button.layer.borderWidth = 0
            }
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
