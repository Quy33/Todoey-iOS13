//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    

    
    var itemArray = [Item]()
    var selectedCategory : Category1? {
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
//MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user presses
            if textField.text!.isEmpty {
                return
            }else{
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTFX) in
            alertTFX.placeholder = "Create new item"
            textField = alertTFX
        }
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - TableViewDataSourceMethod
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID2, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
//MARK: - TableViewDelegateMethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
//        context.delete(item)
//        itemArray.remove(at: indexPath.row)
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//MARK: - Model Manipulation Method
    func saveData() {
        do{
            try context.save()
        }catch{
           print("error saving :\(error)")
        }
        self.tableView.reloadData()
    }
    ///Give loadData a default value
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, predicate: predicate)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}