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
        var boardSceneState: BoardSceneCore.State?
    }
    
    enum Action: Equatable {
        case authAction(AuthCore.Action)
        case boardSceneAction(BoardSceneCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .authAction(.signInAction(._signInWithEmailAndPassword(.success(let user)))):
                state.user = user
                state.boardSceneState?.user = user
                state.boardSceneState = BoardSceneCore.State()
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.boardSceneState, action: /Action.boardSceneAction) {
            BoardSceneCore()
        }
        
//        Scope(state: \.boardSceneState, action: /Action.boardSceneAction) {
//            BoardSceneCore()
//        }
        
        Scope(state: \.authState, action: /Action.authAction) {
            AuthCore()
        }
    }
}
