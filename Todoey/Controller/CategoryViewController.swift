//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mcrew Tech on 17/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.rowHeight = 80.0
    }
    //MARK: - Add Category
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text!.isEmpty {
                return
            }else{
                let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTFX) in
            alertTFX.placeholder = "Create new Category"
            textField = alertTFX
        }
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID1, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category here"
        return cell
    }

    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itemSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationTBVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow{
            destinationTBVC.selectedCategory = categoryArray?[index.row]
        }
        
    }

    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
           print("error saving :\(error)")
        }
        self.tableView.reloadData()
    }
    ///Give loadData a default value
    func loadCategory(){
        categoryArray = realm.objects(Category.self)
    }
}
//MARK: - SwipeTableViewCellDelegate Methods
//extension CategoryViewController : SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//
//            if let categoryForDel = self.categoryArray?[indexPath.row] {
//                do{
//                    try self.realm.write{
//                        self.realm.delete(categoryForDel)
//                    }
//                }catch{
//                    print("error deleting category: \(error)")
//                }
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
//
//        return [deleteAction]
//    }
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//
//}

