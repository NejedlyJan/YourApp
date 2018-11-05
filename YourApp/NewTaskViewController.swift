//
//  NewTaskViewController.swift
//  YourApp
//
//  Created by honza on 02/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class NewTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleInputOutlet: UITextField!
    @IBOutlet weak var categoryInputOutlet: UITextField!
    @IBOutlet weak var dueDateInputOutlet: UITextField!
    @IBOutlet weak var dueDateSwitchOutlet: UISwitch!
    @IBOutlet weak var categorySwitchOutlet: UISwitch!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedColorButtonTag = 1
    var selectedCategory: Int?
    var selectedDueDate: Date?
    var editTask: Task?
    let taskVC = ListViewController()
    let notificationManager = NotificationManager()
    
    
    
    override func viewDidLoad() {
        
        loadCategories()
        selectButton()
        setupPickerViews()
        setupPickerToolbar()
        
        if editTask != nil {
            fillTaskToEdit()
        }
        
    }
    
    func setTask(task: Task) {
        editTask = task
    }
    
    func fillTaskToEdit() {
        titleInputOutlet.text = editTask?.title
        selectedColorButtonTag = Int(editTask!.categoryColor)
        selectButton()
        if let category = editTask?.parentCategory {
            categoryInputOutlet.text = category.name
            categorySwitchOutlet.isOn = true
        }
        if let date = editTask?.dueDate {
            dueDateInputOutlet.text = date.formatDate()
            dueDateSwitchOutlet.isOn = true
        }
        submitButtonOutlet.setTitle("Update task", for: .normal)
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonClicked))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    @objc func deleteButtonClicked() {
        context.delete(editTask!)
        saveItems()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        if titleInputOutlet.text == "" || (categorySwitchOutlet.isOn && categoryInputOutlet.text == "") || (dueDateSwitchOutlet.isOn && dueDateInputOutlet.text == "") {
            showAlert()
            return
        }
        
        let item = editTask ?? Task(context: self.context)
        
        item.done = false
        item.categoryColor = Int32(selectedColorButtonTag)
        item.title = titleInputOutlet.text
        if selectedCategory != nil {
            item.parentCategory = categoryArray[selectedCategory!]
        }
        else {
            item.parentCategory = nil
        }
        item.dueDate = selectedDueDate
       
        if selectedDueDate != nil {
            notificationManager.addNotifiaction(item)
        }
        
        saveItems()
      
    }
    
    func showAlert(message: String = "Please fill all required inputs") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("done")
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
    fileprivate func setupPickerViews() {
        
        if !categoryArray.isEmpty {
            let pickerView  = UIPickerView()
            pickerView.delegate = self
            categoryInputOutlet.inputView = pickerView
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.locale = NSLocale(localeIdentifier: "cs") as Locale
        dueDateInputOutlet.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    fileprivate func setupPickerToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spacingButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spacingButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryInputOutlet.inputAccessoryView = toolBar
        dueDateInputOutlet.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked() {
        categoryInputOutlet.resignFirstResponder()
        dueDateInputOutlet.resignFirstResponder()
    }
    
    @IBAction func categorySwitchClicked(_ sender: Any) {
        if categorySwitchOutlet.isOn {
            if !categoryArray.isEmpty {
                categoryInputOutlet.isEnabled = true
            }
            else {
                categorySwitchOutlet.isOn = false
                showAlert(message: "No categories, please add one in the settings page")
            }
        }
        else {
            categoryInputOutlet.isEnabled = false
            categoryInputOutlet.text = ""
            selectedCategory = nil
        }
}
    @IBAction func dueDateSwitchClicked(_ sender: Any) {
        if dueDateSwitchOutlet.isOn {
            dueDateInputOutlet.isEnabled = true
        }
        else {
            dueDateInputOutlet.isEnabled = false
            dueDateInputOutlet.text = ""
            selectedDueDate = nil
        }
    }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        dueDateInputOutlet.text = sender.date.formatDate()
        selectedDueDate = sender.date
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputOutlet.text = categoryArray[row].name
        selectedCategory = row
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray =  try context.fetch(request)
        }
        catch {
            print("Error fetching data \(error)")
        }
    }
    
    func saveItems() {
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        do {
            try context.save()
            print("Saving to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
        activityIndicator.stopAnimating()
        navigationController?.popViewController(animated: true)
    }
    
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        let formattedString = dateFormatter.string(from: self)
        return formattedString
    }
}
