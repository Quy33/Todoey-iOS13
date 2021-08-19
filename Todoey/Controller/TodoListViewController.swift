//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBarOL: UISearchBar!
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.colorCategory {
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("navigation controller does not exist.")
            }
            title = selectedCategory!.name
            
            if let navBarCL = UIColor(hexString: colorHex) {
                let contrastCl = ContrastColorOf(navBarCL, returnFlat: true)
                navBar.backgroundColor = navBarCL
                navBar.tintColor = contrastCl
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastCl]
                searchBarOL.barTintColor = navBarCL
                searchBarOL.searchTextField.textColor = navBarCL
                searchBarOL.searchTextField.backgroundColor = contrastCl
            }
        }
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("There was an error saving data\(error)")
                    }
                }
                
            }
            self.tableView.reloadData()
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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.colorCategory)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            
            cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items added"
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
//MARK: - TableViewDelegateMethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("There was an error updating item: \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ///Give loadData a default value
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    //MARK: - Delete Data by swipe
    override func updateModel(at indexPath: IndexPath) {
        if let safeItem = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(safeItem)
                }
            } catch {
                print("error deleting: \(error)")
            }
        }
    }
}
//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty{
            return
        } else {
            todoItems = todoItems?
                .filter("title CONTAINS[cd] %@", searchBar.text!)
                .sorted(byKeyPath: "dateCreated" , ascending: true)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
//MARK: - SearchBarConfig

