//
//  ViewController.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 27/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Find Eggos", "Destroy Demogorgon"]
    
    // Define referance to the user Defaults
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //Mark: Tableview Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //Mark: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            
            // Save updated itemArray in to the User Defaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // Reload the data source
            self.tableView.reloadData()
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
    
}

