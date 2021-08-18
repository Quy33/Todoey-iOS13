//
//  Items.swift
//  Todoey
//
//  Created by Mcrew Tech on 18/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var colorItem : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: K.relation) //Reverse relationship
    
}
