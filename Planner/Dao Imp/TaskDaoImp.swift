//
//  TaskDaoImp.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import CoreData

class TaskDaoImp: TaskDao {
    
    typealias Item = Task
    
    var items: [Task]!
    
//    private let categoryDao = CategoryDaoImp.current
//    private let priorityDao = PriorityDaoImp.current
    
    // singleton
    static let current = TaskDaoImp()
    private init() {
        _ = getAll() // FIXME: stupid 
    }
    
    
    // MARK: DAO
    func addOrUpdate(_ task: Task) {
        if !items.contains(task) {
            items.append(task)
        }
        
        save()
    }
    
    func getAll() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetch failed")
        }
        
        return items
    }
    
    func delete(_ item: Task) {
        context.delete(item)
        save()
    }
    
    func search(text: String) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        var params = [Any]()
        var sql = "name CONTAINS[c] %@"
        
        params.append(text)
        var predicate = NSPredicate(format: sql, argumentArray: params)
        fetchRequest.predicate = predicate
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetch failed")
        }
        
        return items
    }
}
