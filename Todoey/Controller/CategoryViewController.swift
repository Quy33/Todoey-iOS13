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
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        loadCategory()
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
                newCategory.colorCategory = UIColor.randomFlat().hexValue()
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cellCL = categoryArray?[indexPath.row].colorCategory
        cell.backgroundColor = UIColor(hexString: cellCL ?? "00C1D4")
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category here"
        return cell
    }

    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itemSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            let categoryCL = categoryArray?[index.row].colorCategory
            destinationVC.selectedCategory = categoryArray?[index.row]
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
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        if let categoryForDel = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDel)
                }
            }catch{
                print("error deleting category: \(error)")
            }
        }
    }
}


