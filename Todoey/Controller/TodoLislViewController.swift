//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoLislViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent(K.keyArr)
    
    
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
                let newItem = Item()
                newItem.Title = textField.text!
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
        
        cell.accessoryType = item.Done ? .checkmark : .none
        
        cell.textLabel?.text = itemArray[indexPath.row].Title
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
//MARK: - TableViewDelegateMethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.Done = !item.Done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//MARK: - Model Manipulation Method
    func saveData() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("There was an error encoding: \(error)")
        }
        self.tableView.reloadData()
    }
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("There was an error decoding: \(error)")
            }
        }
        
    }
}

