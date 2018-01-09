//
//  CategotyViewController.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 30/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import UIKit
import RealmSwift

class CategotyViewController: UITableViewController {
    
    // Realm Implemetation
    let realm = try! Realm()
    
    // Define result object of Categories
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        // Load Catagories from DB
        loadCategories()
    }
    
    //Mark: - Add new Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Define global TextField
        var textField = UITextField()
        
        // Define Alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Define Action
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Action after user clicks the Add Category Button : Append to the Category Array
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        // Add Action to the Alert
        alert.addAction(action)
        
        // Add TextField to Alert
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Category"
        }
        
        // Disply the Alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //Mark: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Define category object and reflects its properties in table view
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    func save(category: Category) {
        
        // Realm Implemetation
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories : \(error)")
        }
        
        // Reload the data source
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
