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
