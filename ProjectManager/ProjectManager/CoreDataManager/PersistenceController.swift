//
//  PersistenceController.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project")
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
        
        return container
    }()
    
    private lazy var context = container.viewContext
    
    func loadAssignments(state: ProjectState) -> [Assignment] {
        let request = Assignment.fetchRequest()
        let predicate = NSPredicate(format: "state == %i", state.rawValue)
        request.predicate = predicate
        
        guard let assignments = try? context.fetch(request) else { return [] }
        
        return assignments
    }
    
    func saveProject(with project: Project) -> Bool {
        let object = Assignment(context: context)
        
        object.id = project.id
        object.title = project.title
        object.body = project.description
        object.state = Int32(project.state.rawValue)
        object.deadLineDate = project.date
        
        return save()
    }
    
    func deleteProject(with project: Project) -> Bool {
        let fetchRequest = Assignment.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", project.id.uuidString)
        fetchRequest.predicate = predicate
        
        guard let assignments = try? context.fetch(fetchRequest) else {
            return false
        }
        
        for assignment in assignments {
            context.delete(assignment)
        }
        
        return save()
    }
    
    private func save() -> Bool {
        if context.hasChanges {
            guard let _ = try? context.save() else {
                return false
            }
            
            return true
        } else {
            return false
        }
    }
}

//struct PersistenceController {
//  static let shared = PersistenceController()
//
//  let container: NSPersistentContainer
//
//  init(inMemory: Bool = true) {
//    container = NSPersistentContainer(name: "Project")
//    container.loadPersistentStores { _, error in
//      if let error = error as? NSError {
//        fatalError("Unresolved error \(error), \(error.userInfo)")
//      }
//    }
//  }
//
//  var context: NSManagedObjectContext {
//    return container.viewContext
//  }
//
//  func saveAssignment(project: Project) -> Bool {
//    let newAssignment = Assignment(context: context)
//    newAssignment.setValue(project.id, forKey: "id")
//    newAssignment.setValue(project.title, forKey: "title")
//    newAssignment.setValue(project.description, forKey: "body")
//    newAssignment.setValue(project.date, forKey: "deadLineDate")
//    newAssignment.setValue(Int32(project.state.rawValue), forKey: "state")
//
//    return saveContext()
//  }
//
//  func fetchAll() -> Projects {
//    guard let assignments = try? context.fetch(Assignment.fetchRequest()) else {
//      return [:]
//    }
//    let projects = assignments.map { $0.convertProject() }
//
//    print(projects)
//    return Dictionary(grouping: projects) { $0.state }
//  }
//
//  func updateAssignment(project: Project) -> Projects {
//    let request = Assignment.fetchRequest()
//    request.predicate = NSPredicate(format: "id = %@", project.id.uuidString)
//
//    do {
//      let datas = try context.fetch(request)
//
//      for data in datas {
//        data.state = Int32(project.state.rawValue)
//      }
//      saveContext()
//
//      return fetchAll()
//    } catch {
//      return [:]
//    }
//  }
//
//  @discardableResult
//  func saveContext() -> Bool {
//    let context = container.viewContext
//
//    if context.hasChanges {
//      do {
//        try context.save()
//        return true
//      } catch {
//        return false
//      }
//    } else {
//      return false
//    }
//  }
//}
