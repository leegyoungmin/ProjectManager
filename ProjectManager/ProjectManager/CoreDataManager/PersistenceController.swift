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
                fatalError("Unalb to load PersistentStore \(error)")
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
