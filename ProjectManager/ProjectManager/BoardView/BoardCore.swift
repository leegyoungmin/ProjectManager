//
//  BoardCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct BoardState {
  var todoListState = BoardListState(status: .todo)
  var doingListState = BoardListState(status: .doing)
  var doneListState = BoardListState(status: .done)
}

enum BoardAction {
  // User Action
  
  // Inner Action
  
  // Child Action
  case todoListAction(BoardListAction)
  case doingListAction(BoardListAction)
  case doneListAction(BoardListAction)
}

struct BoardEnvironment {
  
}

let boardReducer = Reducer<BoardState, BoardAction, BoardEnvironment>.combine([
  boardListReducer
    .pullback(
      state: \.todoListState,
      action: /BoardAction.todoListAction,
      environment: { _ in BoardListEnvironment(
        coreDataClient: .live,
        mainQueue: .main
      ) }
    ),
  
  boardListReducer
    .pullback(
      state: \.doingListState,
      action: /BoardAction.doingListAction,
      environment: { _ in BoardListEnvironment(
        coreDataClient: .live,
        mainQueue: .main
      ) }
    ),
  
  boardListReducer
    .pullback(
      state: \.doneListState,
      action: /BoardAction.doneListAction,
      environment: { _ in BoardListEnvironment(
        coreDataClient: .live, mainQueue: .main
      ) }
    ),

  Reducer<BoardState, BoardAction, BoardEnvironment> { state, action, environment in
    switch action {
    case .todoListAction:
      return .none
      
    case .doingListAction:
      return .none
      
    case .doneListAction:
      return .none
    }
  }
])
