//
//  ViewController.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 27/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // Access AppDelegate class as an object
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Define referance to the user Defaults
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // File path to the custom plist
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        contex.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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
            
            let newItem = Item(context: self.contex)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    func saveItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            try contex.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Reload the data source
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categotyPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate, predicate!])
        } else {
            request.predicate = categotyPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try contex.fetch(request)
            print("Item Array: \(itemArray.count)")
        } catch {
            print("Error in fetching items from context \(error)")
        }
        
        // Reload the table view
        tableView.reloadData()
    }
}

//Mark: Search Bar Delegate Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /*
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Define a predicte - search term
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        // Define a sort descriptor - sorting
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Fetch the data based on request
        do {
            itemArray = try contex.fetch(request)
            print("Item Array: \(itemArray.count)")
        } catch {
            print("Error in fetching items from context \(error)")
        }
        
        // Reload the table view
        tableView.reloadData()
        */
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Define a predicte - search term
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Define a sort descriptor - sorting
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Fetch the data based on request
        loadItems(with: request, predicate: predicate)
    }
    
    // Triggers when the text of the search box changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Text changed and no texts avalible (similar to user clicks the cancel cross of the search box
        if(searchBar.text?.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}

