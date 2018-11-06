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
    let dataMan = DataManager()
    
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        itemArray = dataMan.getItem(Task.self)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        itemArray = dataMan.getItem(Task.self)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! CustomTableViewCell
        let backgroundColorIndex = Int(itemArray[indexPath.row].categoryColor)
        cell.cellLabelOutlet.text = itemArray[indexPath.row].title
        cell.labelColorOutlet.backgroundColor = returnColorforIndex(backgroundColorIndex)
        let formattedDate = itemArray[indexPath.row].dueDate?.formatDate()
        cell.dateLabelOutlet.text = formattedDate
        cell.categoryLabelOutlet.text = itemArray[indexPath.row].parentCategory?.name
        cell.tintColor = returnColorforIndex(backgroundColorIndex)
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    fileprivate func returnColorforIndex(_ index: Int) -> UIColor {
        let backgroundColor: UIColor
        switch index {
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
        return backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        let text = cell.cellLabelOutlet.text
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        if !itemArray[indexPath.row].done {
            cell.cellLabelOutlet.attributedText = attributeString
            itemArray[indexPath.row].done = true
        }
        else {
            cell.cellLabelOutlet.attributedText = nil
            cell.cellLabelOutlet.text = itemArray[indexPath.row].title
            itemArray[indexPath.row].done = false
        }
        dataMan.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataMan.deleteTask(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            dataMan.saveItems()
            
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.row)
        let task = itemArray[indexPath.row]
        print(task)

        let controller = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as! NewTaskViewController
        controller.setTask(task: task)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    
    
}

