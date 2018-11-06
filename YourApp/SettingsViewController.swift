//
//  SettingsViewController.swift
//  YourApp
//
//  Created by honza on 03/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var settingSwitchOutlet: UISwitch!
    @IBOutlet weak var newCategoryInputOutlet: UITextField!
    let dataMan = DataManager()
    let notificationMan = NotificationManager()
    var categoryNames = [String]()
    
    
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        for category in dataMan.getItem(Category.self) {
            categoryNames.append(category.name!)
        }
        
        newCategoryInputOutlet.delegate = self
        newCategoryInputOutlet.returnKeyType = UIReturnKeyType.done
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSwitch), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCategoryInputOutlet.resignFirstResponder()
        return true
    }
    @objc func updateSwitch() {
        setupSwitch()
    }
    
    fileprivate func setupSwitch() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(){ (settings) in
            
            switch settings.alertSetting{
            case .enabled:
                self.operateSwitch(true)
            case .disabled:
                self.operateSwitch(false)
            case .notSupported:
                print("somethings wrong here")
            }
        }
    }
    func operateSwitch(_ isOn: Bool) {
        DispatchQueue.main.async(execute: {
            self.settingSwitchOutlet.isOn = isOn
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSwitch()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        var title = "Success"
        var message = "New category successfuly saved"
        if newCategoryInputOutlet.text == "" {
            title = "Error adding new category"
            message = "Please fill the category name"
            notificationMan.showAlert(title: title, message: message, view: self)
            return
        }
        else if categoryNames.contains(newCategoryInputOutlet.text!) {
            title = "Error adding new category"
            message = "This category name is already added"
            notificationMan.showAlert(title: title, message: message, view: self)
            return
        }
        categoryNames.append(newCategoryInputOutlet.text!)
        let newItem = Category(context: dataMan.getContext())
        newItem.name = newCategoryInputOutlet.text
        dataMan.saveItems()
        notificationMan.showAlert(title: title, message: message, view: self)
        return
        
    }
}
