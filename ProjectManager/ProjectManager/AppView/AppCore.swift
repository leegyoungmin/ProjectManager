//
//  AppStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture

struct AppState {
  var sheetState = SheetState()
  var boardState = BoardState()
}

enum AppAction {
  // User Action
  
  // Inner Action
  
  // Child Action
  case sheetAction(SheetAction)
  case boardAction(BoardAction)
}

struct AppEnvironment {
  var coreDataClient: CoreDataClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine([
  sheetReducer
    .pullback(
      state: \.sheetState,
      action: /AppAction.sheetAction,
      environment: { _ in SheetEnvironment(
        coreDataClient: .live,
        mainQueue: .main
      ) }
    ),
  boardReducer
    .pullback(
      state: \.boardState,
      action: /AppAction.boardAction,
      environment: { _ in BoardEnvironment() }
    ),
  
  Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .sheetAction:
      return .none
      
    case .boardAction:
      return .none
    }
  }
])
