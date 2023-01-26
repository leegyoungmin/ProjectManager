//
//  Project.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture
import SwiftUI
import CoreData

struct Project: Codable, Identifiable, Equatable {
  var id = UUID()
  let title: String
  let date: Date
  let description: String
  var state: ProjectState = .todo
}

extension Project {
  var dateColor: Color {
    return self.date.onlyDate() <= Date().onlyDate() ? .red : .black
  }
}

enum ProjectState: Int, Codable {
  case todo = 1
  case doing = 2
  case done = 3
  
  var description: String {
    switch self {
    case .todo:
      return "TODO"
    case .doing:
      return "DOING"
    case .done:
      return "DONE"
    }
  }
}
