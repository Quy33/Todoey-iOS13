//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoLislViewController: UITableViewController {
    

    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath)
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
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do{
           itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}
//MARK: - UISearchBarDelegate
extension TodoLislViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request)
    }
}
