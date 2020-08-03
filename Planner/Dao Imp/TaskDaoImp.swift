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
    
    let sortByPriority = NSSortDescriptor(key: #keyPath(Task.priority.index), ascending: false)
    let sortByDate = NSSortDescriptor(key: #keyPath(Task.deadline), ascending: false)
    let sortByName = NSSortDescriptor(key: #keyPath(Task.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
    
    // singleton
    static let current = TaskDaoImp()
    private init() {
        _ = getAll(sortedBy: .complex) // FIXME: stupid
    }
    
    
    // MARK: DAO
    func addOrUpdate(_ task: Task) {
        if !items.contains(task) {
            items.append(task)
        }
        save()
    }
    
    func getAll(sortedBy: SortType) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        switch sortedBy {
        case .date:
            fetchRequest.sortDescriptors = [sortByDate]
        case .name:
            fetchRequest.sortDescriptors = [sortByName]
        case .priority:
            fetchRequest.sortDescriptors = [sortByPriority]
        case .complex:
            fetchRequest.sortDescriptors = [sortByPriority, sortByDate, sortByName]
        default:
            fetchRequest.sortDescriptors = []
        }

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
    
    func search(text: String, sortedBy: SortType) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        switch sortedBy {
        case .date:
            fetchRequest.sortDescriptors = [sortByDate]
        case .name:
            fetchRequest.sortDescriptors = [sortByName]
        case .priority:
            fetchRequest.sortDescriptors = [sortByPriority]
        case .complex:
            fetchRequest.sortDescriptors = [sortByPriority, sortByDate, sortByName]            
        default:
            fetchRequest.sortDescriptors = []
        }
        
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
