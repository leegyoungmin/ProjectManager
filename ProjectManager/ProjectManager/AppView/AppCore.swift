//
//  AppStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture

struct AppCore: ReducerProtocol {
    struct State: Equatable {
        var authState = AuthCore.State()
        var navigationBarState = NavigationBarCore.State()
        var boardState = BoardCore.State()
    }
    
    enum Action: Equatable {
        case authAction(AuthCore.Action)
        case navigationBarAction(NavigationBarCore.Action)
        case boardAction(BoardCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.authState, action: /Action.authAction) {
            AuthCore()
        }
        
        Scope(state: \.navigationBarState, action: /Action.navigationBarAction) {
            NavigationBarCore()
        }
        
        Scope(state: \.boardState, action: /Action.boardAction) {
            BoardCore()
        }
    }
}
