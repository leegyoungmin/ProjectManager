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
    container = NSPersistentContainer(name: "Project")
    container.loadPersistentStores { _, error in
      if let error = error as? NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  var context: NSManagedObjectContext {
    return container.viewContext
  }
  
  func saveAssignment(project: Project) -> Bool {
    let newAssignment = Assignment(context: context)
    newAssignment.setValue(project.id, forKey: "id")
    newAssignment.setValue(project.title, forKey: "title")
    newAssignment.setValue(project.description, forKey: "body")
    newAssignment.setValue(project.date, forKey: "deadLineDate")
    
    return saveContext()    
  }
  
  func saveContext() -> Bool {
    let context = container.viewContext
    
    if context.hasChanges {
      do {
        try context.save()
        return true
      } catch {
        return false
      }
    } else {
      return false
    }
  }
}
