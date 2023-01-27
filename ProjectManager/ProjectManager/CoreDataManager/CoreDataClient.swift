//
//  CoreDataClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import Foundation
import CoreData
import ComposableArchitecture

typealias Projects = [Project]

struct CoreDataClient {
  var fetchProjects: () -> Effect<Projects, Failure>
  var saveProject: (Project) -> Effect<Bool, Failure>
  var updateProject: (Project) -> Effect<Bool, Failure>
  
  struct Failure: Error, Equatable { }
}

extension CoreDataClient {
  static let live = Self(
    fetchProjects: {
      Effect.task {
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        guard let projects = try? PersistenceController.shared.context.fetch(fetchRequest) else {
          return []
        }
        return projects.compactMap { $0.convertProject() }
      }
      .mapError { _ in CoreDataClient.Failure() }
      .eraseToEffect()
    }, saveProject: { project in
      Effect.task {
        let result = PersistenceController.shared.saveAssignment(project: project)
        return result
      }
      .mapError { _ in CoreDataClient.Failure() }
      .eraseToEffect()
    }, updateProject: { newItem in
      Effect.task {
        let result = PersistenceController.shared.updateAssignment(project: newItem)
        return result
      }
      .mapError { _ in CoreDataClient.Failure() }
      .eraseToEffect()
    }
  )
}
