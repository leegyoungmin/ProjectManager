////
////  BoardCore.swift
////  ProjectManager
////
////  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct BoardCore: ReducerProtocol {
    struct State: Equatable {
        var todoListState = BoardListCore.State(projectState: .todo)
        var doingListState = BoardListCore.State(projectState: .doing)
        var doneListState = BoardListCore.State(projectState: .done)
    }
    
    enum Action: Equatable {
        // Child Action
        case todoAction(BoardListCore.Action)
        case doingAction(BoardListCore.Action)
        case doneAction(BoardListCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        
        Scope(state: \.todoListState, action: /Action.todoAction) {
            BoardListCore()
        }
        
        Scope(state: \.doingListState, action: /Action.doingAction) {
            BoardListCore()
        }
        
        Scope(state: \.doneListState, action: /Action.doneAction) {
            BoardListCore()
        }
    }
}


//
//import ComposableArchitecture
//
//struct BoardState: Equatable {
//  var todoListState = BoardListState(status: .todo)
//  var doingListState = BoardListState(status: .doing)
//  var doneListState = BoardListState(status: .done)
//}
//
//enum BoardAction {
//  // User Action
//
//  // Inner Action
//  case _onAppear
//  case _movingItem(Project)
//  case _fetchProjectsResponse(Result<Projects, CoreDataClient.Failure>)
//
//  // Child Action
//  case todoListAction(BoardListAction)
//  case doingListAction(BoardListAction)
//  case doneListAction(BoardListAction)
//}
//
//struct BoardEnvironment {
//  var coreDataClient: CoreDataClient
//}
//
//let boardReducer = Reducer<BoardState, BoardAction, BoardEnvironment>.combine([
//  boardListReducer
//    .pullback(
//      state: \.todoListState,
//      action: /BoardAction.todoListAction,
//      environment: { _ in BoardListEnvironment(
//        coreDataClient: .live,
//        mainQueue: .main
//      ) }
//    ),
//
//  boardListReducer
//    .pullback(
//      state: \.doingListState,
//      action: /BoardAction.doingListAction,
//      environment: { _ in BoardListEnvironment(
//        coreDataClient: .live,
//        mainQueue: .main
//      ) }
//    ),
//
//  boardListReducer
//    .pullback(
//      state: \.doneListState,
//      action: /BoardAction.doneListAction,
//      environment: { _ in BoardListEnvironment(
//        coreDataClient: .live, mainQueue: .main
//      ) }
//    ),
//
//  Reducer<BoardState, BoardAction, BoardEnvironment> { state, action, environment in
//    switch action {
//
//    case ._onAppear:
//      return environment.coreDataClient.fetchProjects()
//        .catchToEffect(BoardAction._fetchProjectsResponse)
//
//    case let ._fetchProjectsResponse(.success(projectsDictionary)):
//      projectsDictionary.forEach {
//        switch $0.key {
//        case .todo:
//          state.todoListState.projects = $0.value
//        case .doing:
//          state.doingListState.projects = $0.value
//        case .done:
//          state.doneListState.projects = $0.value
//        }
//      }
//      return .none
//
//    case ._fetchProjectsResponse(.failure):
//      return .none
//
//    case let .todoListAction(.movingToDoing(project)), let .doneListAction(.movingToDoing(project)):
//      var newItem = project
//      newItem.state = .doing
//      return Effect(value: ._movingItem(newItem))
//
//    case let .todoListAction(.movingToDone(project)), let .doingListAction(.movingToDone(project)):
//      var newItem = project
//      newItem.state = .done
//      return Effect(value: ._movingItem(newItem))
//
//    case let .doingListAction(.movingToTodo(project)), let .doneListAction(.movingToTodo(project)):
//      var newItem = project
//      newItem.state = .todo
//      return Effect(value: ._movingItem(newItem))
//
//    case let ._movingItem(newItem):
//      return environment.coreDataClient.updateProject(newItem)
//        .catchToEffect(BoardAction._fetchProjectsResponse)
//
//    case .todoListAction:
//      return .none
//
//    case .doingListAction:
//      return .none
//
//    case .doneListAction:
//      return .none
//    }
//  }
//]).debug()
