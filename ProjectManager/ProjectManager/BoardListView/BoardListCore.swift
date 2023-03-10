//
//  BoardListState.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture
import SwiftUI

struct BoardListState: Equatable {
  var projects: [Project] = []
  var targetItem: Project?
  var status: ProjectState
  
  var selectedProject: DetailState?
}

enum BoardListAction {
  // User Action
  case tapDelete(Project)
  case tapDetailShow(Project)
  case movingToTodo(Project)
  case movingToDoing(Project)
  case movingToDone(Project)
  
  // Inner Action
  case _onAppear
  case _dismissItem
  case _createDetailState(Project)
  case _deleteProject(Project)
  
  // Child Action
  case detailAction(DetailAction)
}

struct BoardListEnvironment {
  var coreDataClient: CoreDataClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let boardListReducer = Reducer<BoardListState, BoardListAction, BoardListEnvironment>.combine([
  detailReducer
    .optional()
    .pullback(
      state: \.selectedProject,
      action: /BoardListAction.detailAction,
      environment: { _ in DetailEnvironment()}
    ),
  Reducer<BoardListState, BoardListAction, BoardListEnvironment> { state, action, environment in
    switch action {
    case let .tapDelete(project):
      return Effect(value: ._deleteProject(project))
      
    case let .tapDetailShow(project):
      return Effect(value: ._createDetailState(project))
      
    case let .movingToDoing(project), let .movingToDone(project), let .movingToTodo(project):
      guard let index = state.projects.firstIndex(of: project) else {
        return .none
      }
      
      state.projects.remove(at: index)
      return .none
      
    case ._onAppear:
      return .none
      
    case ._dismissItem:
      state.selectedProject = nil
      return .none
      
    case let ._createDetailState(project):
      let existingState = DetailState(
        id: project.id,
        projectStatus: project.state,
        title: project.title,
        description: project.description,
        deadLineDate: project.date,
        editMode: true
      )
      state.selectedProject = existingState
      return .none
      
    case .detailAction(.didDoneTap):
      guard let selectedState = state.selectedProject,
            let index = state.projects.firstIndex(where: { $0.id == selectedState.id }) else {
        return .none
      }
      
      let newItem = Project(
        id: selectedState.id,
        title: selectedState.title,
        date: selectedState.deadLineDate,
        description: selectedState.description
      )
      state.projects[index] = newItem
      return Effect(value: ._dismissItem)
      
      
    case let ._deleteProject(project):
      guard let firstIndex = state.projects.firstIndex(where: { $0.id == project.id }) else { return .none }
      state.projects.remove(at: firstIndex)
      return .none
      
    case .detailAction:
      return .none
      
    }
  }
])
