//
//  ViewController.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 27/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // File path to the custom plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //print(dataFilePath)
    
    // Define referance to the user Defaults
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Buy Eggos"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Destroy Demogorgon"
//        itemArray.append(newItem2)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
    }
    
    //Mark: Tableview Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
//      cell.textLabel?.text = itemArray[indexPath.row].title
        cell.textLabel?.text = item.title
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        // Replace the above code segment with the ternery operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Mark: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark: Add new Items via Alert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Define global TextField
        var textField = UITextField()
        
        // Define Alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // Define Action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Action after user clicks the Add Item Button : Append to the Item Array
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
            // Save updated itemArray in to the User Defaults
            // self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            
        }
        
        // Add TextField to Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        // Add Action to the Alert
        alert.addAction(action)
        
        // Disply the Alert
        present(alert, animated: true, completion: nil)
    }
    
    //Mark: Data model manipulation methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error in creating item array \(error)")
        }
        
        // Reload the data source
        self.tableView.reloadData()
    }
    
    func loadItems() {
    
        do {
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print("Error in decoding items \(error)")
        }
    }
    
}

