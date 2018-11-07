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

class NewTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var titleInputOutlet: UITextField!
    @IBOutlet weak var categoryInputOutlet: UITextField!
    @IBOutlet weak var dueDateInputOutlet: UITextField!
    @IBOutlet weak var dueDateSwitchOutlet: UISwitch!
    @IBOutlet weak var categorySwitchOutlet: UISwitch!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    
    private var categoryArray = [Category]()
    private var selectedColorButtonTag = 1
    private var selectedCategory: Int?
    private var selectedDueDate: Date?
    private var editTask: Task?
    private let taskVC = ListViewController()
    private let notificationManager = NotificationManager()
    private let dataMan = DataManager()
    
    
    
    override func viewDidLoad() {
        titleInputOutlet.delegate = self
        titleInputOutlet.returnKeyType = UIReturnKeyType.done
        
        categoryArray = dataMan.getItem(Category.self)
        selectButton()
        setupPickerViews()
        setupPickerToolbar()
        
        if editTask != nil {
            fillTaskToEdit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if categorySwitchOutlet.isOn {
            categoryInputOutlet.isEnabled = true
        }
        if dueDateSwitchOutlet.isOn {
            dueDateInputOutlet.isEnabled = true
        }
    }
    
    func setTask(task: Task) {
        editTask = task
    }
    
    private func fillTaskToEdit() {
        titleInputOutlet.text = editTask?.title
        selectedColorButtonTag = Int(editTask!.categoryColor)
        selectButton()
        if let category = editTask?.parentCategory {
            categoryInputOutlet.text = category.name
            categorySwitchOutlet.isOn = true
            let categoryName = editTask?.parentCategory?.name
            selectedCategory = categoryArray.index(where: {$0.name == categoryName})
        }
        if let date = editTask?.dueDate {
            dueDateInputOutlet.text = date.formatDate()
            dueDateSwitchOutlet.isOn = true
            selectedDueDate = editTask?.dueDate
        }
        submitButtonOutlet.setTitle("Update task", for: .normal)
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonClicked))
        deleteButton.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc private func deleteButtonClicked() {
        dataMan.getContext().delete(editTask!)
        dataMan.saveItems()
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleInputOutlet.resignFirstResponder()
        return true
    }
    
    @IBAction func changeColor(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        selectedColorButtonTag = button.tag
        selectButton()
    }
    
    private func selectButton() {
        for button in buttonContainer.subviews {
            if button.tag == selectedColorButtonTag {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.blue.cgColor
            }
            else {
                button.layer.borderWidth = 0
            }
        }
    }
    
    private func setupPickerViews() {
        
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
    
    private func setupPickerToolbar() {
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
    
    @objc private func doneClicked() {
        categoryInputOutlet.resignFirstResponder()
        dueDateInputOutlet.resignFirstResponder()
    }
    
    @IBAction func categorySwitchClicked(_ sender: Any) {
        if categorySwitchOutlet.isOn {
            if !categoryArray.isEmpty {
                categoryInputOutlet.isEnabled = true
                categoryInputOutlet.text = categoryArray[0].name
                selectedCategory = 0
            }
            else {
                categorySwitchOutlet.isOn = false
                let title = "No categories"
                let message = "Please add a new category in settings"
                notificationManager.showAlert(title: title, message: message, view: self)
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
            dueDateInputOutlet.text = Date().formatDate()
            selectedDueDate = Date()
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
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        if titleInputOutlet.text == "" || (categorySwitchOutlet.isOn && categoryInputOutlet.text == "") || (dueDateSwitchOutlet.isOn && dueDateInputOutlet.text == "") {
            let title = "Error adding new task"
            let message = "Please fill a title"
            notificationManager.showAlert(title: title, message: message, view: self)
            return
        }
        
        let item = editTask ?? Task(context: dataMan.getContext())
        
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
        
        dataMan.saveItems()
        navigationController?.popViewController(animated: true)
    }
}
