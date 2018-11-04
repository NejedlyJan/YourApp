//
//  ViewController.swift
//  YourApp
//
//  Created by honza on 02/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var itemArray = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let backgroundColor: UIColor
        switch itemArray[indexPath.row].categoryColor {
        case 1:
            backgroundColor = UIColor(red:0.96, green:0.32, blue:0.18, alpha:1.0)
        case 2:
            backgroundColor = UIColor(red:0.47, green:0.65, blue:0.00, alpha:1.0)
        case 3:
            backgroundColor = UIColor(red:1.00, green:0.43, blue:0.51, alpha:1.0)
        case 4:
            backgroundColor = UIColor(red:0.89, green:0.71, blue:0.00, alpha:1.0)
        default:
            backgroundColor = UIColor.white
        }
        cell.backgroundColor = backgroundColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveItems()
            
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
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
    
    func loadItems() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data \(error)")
        }
    }
    
    
}

