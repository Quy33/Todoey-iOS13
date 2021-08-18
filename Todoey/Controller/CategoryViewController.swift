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

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadData()
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
                self.categoryArray.append(newCategory)
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
        categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID1, for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itemSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationTBVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow{
            destinationTBVC.selectedCategory = categoryArray[index.row]
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
//    func loadData(with request : NSFetchRequest<Category1> = Category1.fetchRequest()) {
//        do{
//           categoryArray = try context.fetch(request)
//        }catch{
//            print(error)
//        }
//        tableView.reloadData()

    //}
}
