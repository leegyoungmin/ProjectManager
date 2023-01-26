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
  
  struct Failure: Error, Equatable { }
}

extension CoreDataClient {
  static let live = Self(
    fetchProjects: {
      Effect.task {
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let projects = try PersistenceController.shared.context.fetch(fetchRequest)
        return projects.compactMap { $0.convertProject() }
      }
      .mapError { _ in Failure() }
      .eraseToEffect()
    }
  )
}
