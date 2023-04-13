//
//  BoardSceneCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth

struct BoardSceneCore: ReducerProtocol {
    struct State: Equatable {
        var navigationBarState = NavigationBarCore.State()
        var boardState = BoardCore.State()
        var user: User?
    }
    
    enum Action: Equatable {
        case navigationBarAction(NavigationBarCore.Action)
        case boardAction(BoardCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.navigationBarState, action: /Action.navigationBarAction) {
            NavigationBarCore()
        }
        
        Scope(state: \.boardState, action: /Action.boardAction) {
            BoardCore()
        }
    }
}
