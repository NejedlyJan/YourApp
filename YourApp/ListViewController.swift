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
    
    private var itemArray = [Task]()
    private let dataMananager = DataManager()
    
    override func viewDidAppear(_ animated: Bool) {
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        itemArray = dataMananager.getItem(Task.self)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! CustomTableViewCell
        let task = itemArray[indexPath.row]
        let text = task.title
        let backgroundColorIndex = Int(task.categoryColor)
        let formattedDate = task.dueDate?.formatDate()
        
        if !task.done {
            cell.cellLabelOutlet.text = text
        }
        else {
            cell.cellLabelOutlet.attributedText = text?.getStruckedText()
        }
    
        cell.labelColorOutlet.backgroundColor = returnColorforIndex(backgroundColorIndex)
        cell.dateLabelOutlet.text = formattedDate
        cell.categoryLabelOutlet.text = task.parentCategory?.name
        cell.tintColor = returnColorforIndex(backgroundColorIndex)
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        let text = cell.cellLabelOutlet.text
        let task = itemArray[indexPath.row]
        
        if !task.done {
            cell.cellLabelOutlet.attributedText = text?.getStruckedText()
            task.done = true
        }
        else {
            cell.cellLabelOutlet.attributedText = nil
            cell.cellLabelOutlet.text = task.title
            task.done = false
        }
        dataMananager.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataMananager.deleteTask(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            dataMananager.saveItems()
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let task = itemArray[indexPath.row]
        let newTaskVC = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as! NewTaskViewController
        newTaskVC.setTask(task: task)
        self.navigationController!.pushViewController(newTaskVC, animated: true)
    }
    
    private func returnColorforIndex(_ index: Int) -> UIColor {
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
}

extension String {
    func getStruckedText() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
