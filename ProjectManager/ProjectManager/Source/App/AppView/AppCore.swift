//
//  AppStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture
import FirebaseAuth

struct AppCore: ReducerProtocol {
    struct State: Equatable {
        var user: User?
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
        Reduce { state, action in
            switch action {
            case .authAction(.signInAction(._signInWithEmailAndPassword(.success(let user)))):
                state.user = user
                return .none
                
            default:
                return .none
            }
        }
        
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
