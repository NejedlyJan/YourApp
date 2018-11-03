//
//  NewTaskViewController.swift
//  YourApp
//
//  Created by honza on 02/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleInputOutlet: UITextField!
    @IBOutlet weak var categoryInputOutlet: UITextField!
    @IBOutlet weak var dueDateInputOutlet: UITextField!
    @IBOutlet weak var dueDateSwitchOutlet: UISwitch!
    @IBOutlet weak var categorySwitchOutlet: UISwitch!
    
    
    var categoryArray = [Category]()
//    var categoryNamesArray = ["School", "Work", "Free-time" ]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedColorButtonTag = 1
    
    
    
    override func viewDidLoad() {
        
        loadCategories()
        selectButton()
        setupPickerViews()
        setupPickerToolbar()
        
    }
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        if titleInputOutlet.text == "" || (categorySwitchOutlet.isOn && categoryInputOutlet.text == "") || (dueDateSwitchOutlet.isOn && dueDateInputOutlet.text == "") {
            showAlert()
            return
        }
        let newItem = Task(context: self.context)
        
        newItem.done = false
        newItem.categoryColor = Int32(selectedColorButtonTag)
        newItem.title = titleInputOutlet.text
        
        
        saveItems()
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill all required inputs", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        let pickerView  = UIPickerView()
        pickerView.delegate = self
        categoryInputOutlet.inputView = pickerView
        
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
            categoryInputOutlet.isEnabled = true
            
        }
        else {
            categoryInputOutlet.isEnabled = false
            categoryInputOutlet.text = ""
        }
    }
    @IBAction func dueDateSwitchClicked(_ sender: Any) {
        if dueDateSwitchOutlet.isOn {
            dueDateInputOutlet.isEnabled = true
        }
        else {
            dueDateInputOutlet.isEnabled = false
            dueDateInputOutlet.text = ""
        }
    }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        dueDateInputOutlet.text = dateFormatter.string(from: sender.date)
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
        do {
            try context.save()
            print("Saving to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
    }
    
}
