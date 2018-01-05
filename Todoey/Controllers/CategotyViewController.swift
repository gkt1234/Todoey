//
//  CategotyViewController.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 30/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import UIKit
import CoreData

class CategotyViewController: UITableViewController {

    // Define Category Array
    var categoryArray = [Category]()
    
    // Access AppDelegate class as an object to get a referance to ViewContext to perform CRUD
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Define category object and reflects its properties in table view
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try contex.save()
        } catch {
            print("Error saving categories : \(error)")
        }
        
        // Reload the data source
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try contex.fetch(request)
        } catch {
            print("Error in fetching categories from context : \(error)")
        }
        
        // Reload the table view
        tableView.reloadData()
    }
}
