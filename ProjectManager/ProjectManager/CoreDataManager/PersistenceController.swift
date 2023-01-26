//
//  PersistenceController.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = true) {
    container = NSPersistentContainer(name: "Assignment")
    container.loadPersistentStores { _, error in
      if let error = error as? NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  func saveContext() {
    let context = container.viewContext
    
    if context.hasChanges {
      try? context.save()
    }
  }
}
