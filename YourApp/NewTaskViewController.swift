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
    @IBOutlet weak var categorySwitchOutlet: UISwitch!
    @IBOutlet weak var dueDateSwitchOutlet: UISwitch!
    
    var pickerSelection = ["práce", "škola", "rodina"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedColorButtonTag = 1
    
    override func viewDidLoad() {
        selectButton()
        
        let pickerView  = UIPickerView()
        pickerView.delegate = self
        categoryInputOutlet.inputView = pickerView
        
        setupPickerToolbar()
    }
    
    @IBAction func addItemButtonClicked(_ sender: UIButton) {
        
        let newItem = Task(context: self.context)
        
        newItem.done = false
        newItem.categoryColor = Int32(selectedColorButtonTag)
        newItem.title = titleInputOutlet.text
        
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
    }
    
    @objc func doneClicked() {
        categoryInputOutlet.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSelection.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSelection[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputOutlet.text = pickerSelection[row]
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
