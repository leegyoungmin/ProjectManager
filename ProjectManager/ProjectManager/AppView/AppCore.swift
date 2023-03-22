//
//  AppStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture

struct AppState {
  var sheetState = NavigationBarCore()
//  var boardState = BoardState()
}

enum AppAction {
  // User Action
  
  // Inner Action
  
  // Child Action
    case sheetAction(NavigationBarCore.Action)
//  case boardAction(BoardAction)
}

struct AppEnvironment {
//  var coreDataClient: CoreDataClient
//  var mainQueue: AnySchedulerOf<DispatchQueue>
}

//let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine([
//  SheetCore
//    .pullback(
//      state: \.sheetState,
//      action: /AppAction.sheetAction,
//      environment: { _ in SheetEnvironment(
//        coreDataClient: .live,
//        mainQueue: .main
//      ) }
//    ),
//  boardReducer
//    .pullback(
//      state: \.boardState,
//      action: /AppAction.boardAction,
//      environment: { _ in BoardEnvironment(coreDataClient: .live) }
//    ),
//  
//  Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
//    switch action {
//    case .sheetAction:
//      return .none
//      
//    case .boardAction:
//      return .none
//    }
//  }
//])
