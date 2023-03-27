//
//  Project.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture
import SwiftUI

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

extension Project {
    static let mockData: [Self] = [
        .init(title: "Example1", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 "),
        .init(title: "Example2", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 ", state: .doing),
        .init(title: "Example3", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 ", state: .done),
        .init(title: "Example4", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 ", state: .doing),
        .init(title: "Example5", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 "),
        .init(title: "Example6", date: Date(), description: "Example1 Example1 Example1 Example1 Example1 Example1 Example1 "),
    ]
}

enum ProjectState: Int, Codable, CaseIterable {
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
