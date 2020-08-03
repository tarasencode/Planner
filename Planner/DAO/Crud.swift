//
//  CrudCategory.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import CoreData

protocol Crud{
    
    associatedtype Item: NSManagedObject
    
    var items: [Item]! {get set}
    
    func addOrUpdate(_ category: Item)
    
    func getAll(sortedBy: SortType) -> [Item]
    
    func delete(_ category: Item)
    
}
