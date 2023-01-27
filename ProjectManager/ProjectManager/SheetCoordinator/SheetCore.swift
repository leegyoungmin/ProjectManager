//
//  NavigationStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation

struct SheetState: Equatable {
  var isPresent: Bool = false
  var title: String = "Project Manager"
  var detailState: DetailState?
  
  var createdProject: Project?
}

enum SheetAction {
  // User Action
  case didTapPresent(Bool)
  
  // Inner Action
  case _setIsPresent
  case _setIsNotPresent
  case _createDetailState(id: UUID, currentDate: Date, isEdit: Bool)
  case _deleteDetailState
  case _saveProjectResponse(Result<Bool, CoreDataClient.Failure>)
  
  // Child Action
  case detailAction(DetailAction)
}

struct SheetEnvironment {
  var coreDataClient: CoreDataClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let sheetReducer = Reducer<SheetState, SheetAction, SheetEnvironment>.combine([
  detailReducer
    .optional()
    .pullback(
      state: \.detailState,
      action: /SheetAction.detailAction,
      environment: { _ in DetailEnvironment() }
    ),
  
  Reducer<SheetState, SheetAction, SheetEnvironment> { state, action, environment in
    switch action {
    // UserAction
    case .didTapPresent(true):
      let id = UUID()
      let currentDate = Date()
      let isEdit = false
      
      return Effect.concatenate([
        Effect(value: ._setIsPresent),
        Effect(value: ._createDetailState(id: id, currentDate: currentDate, isEdit: isEdit))
      ])
      
    case .didTapPresent(false):
      return Effect.concatenate([
        Effect(value: ._setIsNotPresent),
        Effect(value: ._deleteDetailState)
      ])
      
    // Inner Action
    case ._setIsPresent:
      state.isPresent = true
      return .none
      
    case ._setIsNotPresent:
      state.isPresent = false
      return .none
      
    case let ._createDetailState(id, date, isEdit):
      state.detailState = DetailState(id: id, deadLineDate: date, editMode: isEdit)
      return .none
      
    case ._deleteDetailState:
      state.detailState = nil
      return .none
      
    // Child Action
    case .detailAction(.didDoneTap):
      guard let detail = state.detailState else { return .none }
      let newItem = Project(
        title: detail.title,
        date: detail.deadLineDate,
        description: detail.description
      )
      return environment.coreDataClient
        .saveProject(newItem)
        .catchToEffect(SheetAction._saveProjectResponse)
//      return Effect.concatenate([
//        Effect(value: ._setIsNotPresent),
//        Effect(value: ._deleteDetailState)
//      ])
      
    case ._saveProjectResponse(.success(true)):
      return Effect.concatenate([
        Effect(value: ._setIsNotPresent),
        Effect(value: ._deleteDetailState)
      ])
      
    case ._saveProjectResponse(.success(false)):
      return Effect.concatenate([
        Effect(value: ._setIsNotPresent),
        Effect(value: ._deleteDetailState)
      ])
      
    case ._saveProjectResponse(.failure):
      return Effect.concatenate([
        Effect(value: ._setIsNotPresent),
        Effect(value: ._deleteDetailState)
      ])
      
    case .detailAction(.didCancelTap):
      return Effect.concatenate([
        Effect(value: ._setIsNotPresent),
        Effect(value: ._deleteDetailState)
      ])
      
    case .detailAction:
      return .none
    }
  }
])
