//
//  DataBase.swift
//  Planner
//
//  Created by oleG on 26/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBase {
    var context: NSManagedObjectContext!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate error")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    func deleteTask(_ task: Task) {
        context.delete(task)
    
        do {
        try context.save()
        } catch let error as NSError {
        print("Can't save category. \(error)")
        }
    }
    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let list: [Task]
        
        do {
            list = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetch failed")
        }
        return list
    }
    
    func addCategory(name: String) -> Category {
        let category = Category(context: context)
        
        category.name = name
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Can't save category. \(error)")
        }
        
        return category
    }
    
    func addTask(name: String, completed: Bool = false, deadline: Date?, info: String?, category: Category?, priority: Priority?) -> Task {
        let task = Task(context: context)
        
        task.name = name
        task.completed = completed
        task.deadline = deadline
        task.info = info
        task.category = category
        task.priority = priority
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Can't save Task \(error)")
        }
        
        return task
    }
    
    func addPriority(name: String, index: Int) -> Priority {
        let priority = Priority(context: context)
        
        priority.name = name
        priority.index = Int16(index)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Can't save Priority \(error)")
        }
        
        return priority
    }
    
    func initTestData() {
        let lowPriority = addPriority(name: "Low", index: 0)
        let midPriority = addPriority(name: "Mid", index: 1)
        let hiPriority = addPriority(name: "Hi", index: 2)
        
        let sportCategory = addCategory(name: "Sport")
        let _ = addTask(name: "Go to swimming pool", deadline: Date().shiftDay(by: -1), info: "adress not set", category: sportCategory, priority: lowPriority)
        
        let businesCategory = addCategory(name: "Busines")
        let _ = addTask(name: "Find clients", deadline: Date().shiftDay(by: 0), info: "Clients for new bussines needed", category: businesCategory, priority: midPriority)
        
        let healthCategory = addCategory(name: "Health")
        let _ = addTask(name: "Take pills", deadline: Date().shiftDay(by: 1), info: "Aspirin", category: healthCategory, priority: hiPriority)
        let _ = addTask(name: "Buy vegitables", deadline: Date().shiftDay(by: 10), info: "Aspirin", category: healthCategory, priority: lowPriority)
    }
}
