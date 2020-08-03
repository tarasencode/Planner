//
//  PriorityDaoImp.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import CoreData

class PriorityDaoImp: Crud {
    
    typealias Item = Priority
    
    var items: [Priority]!
    
    // singleton
    static let current = PriorityDaoImp()
    private init() {}
    
    // MARK: DAO
    func addOrUpdate(_ priority: Priority) {
        if !items.contains(priority) {
            items.append(priority)
        }
        
        save()
    }
    
    func getAll(sortedBy: SortType) -> [Priority] {
        let fetchRequest: NSFetchRequest<Priority> = Priority.fetchRequest()
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetch failed")
        }
        
        return items
    }
    
    func delete(_ priority: Priority) {
        context.delete(priority)
        save()
    }
    
    
    
}
