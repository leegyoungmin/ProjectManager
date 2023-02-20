//
//  CoreDataClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import Foundation
import CoreData
import ComposableArchitecture

typealias Projects = [ProjectState: [Project]]

struct CoreDataClient {
  var fetchProjects: () -> Effect<Projects, Failure>
  var saveProject: (Project) -> Effect<Bool, Failure>
  var updateProject: (Project) -> Effect<Projects, Failure>
  
  struct Failure: Error, Equatable { }
}

extension Sequence {
  func toDictionary<Key: Hashable>(with selectKey: (Iterator.Element) -> Key) -> [Key: Iterator.Element] {
    var dict: [Key: Iterator.Element] = [:]
    
    for element in self {
      dict[selectKey(element)] = element
    }
    return dict
  }
}

extension CoreDataClient {
  static let live = Self(
    fetchProjects: {
      Effect.task {
        return PersistenceController.shared.fetchAll()
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
