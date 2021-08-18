//
//  SwipeTableTableViewController.swift
//  Todoey
//
//  Created by Mcrew Tech on 18/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Delete Cell")
//            if let categoryForDel = self.categoryArray?[indexPath.row] {
//                do{
//                    try self.realm.write{
//                        self.realm.delete(categoryForDel)
//                    }
//                }catch{
//                    print("error deleting category: \(error)")
//                }
//            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
