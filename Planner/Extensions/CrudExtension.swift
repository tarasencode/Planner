//
//  CrudExtension.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Crud {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
