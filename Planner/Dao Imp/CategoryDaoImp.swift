//
//  CategoryDaoImp.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import CoreData

class CategoryDaoImp: Crud {
    
    typealias Item = Category
    
    var items: [Category]!
  
    // singleton
    static let current = CategoryDaoImp()
    private init() {}   
    
    // MARK: DAO
    func addOrUpdate(_ category: Category) {
        if !items.contains(category) {
            items.append(category)
        }
        
        save() 
    }
    
    func getAll() -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()

        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetch failed")
        }
        
        return items
    }
    
    func delete(_ category: Category) {
        context.delete(category)
        save()
    }
    
  
    
}
