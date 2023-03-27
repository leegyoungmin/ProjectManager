//
//  AuthCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth

struct AuthCore: ReducerProtocol {
    struct State: Equatable {
        var signInState = SignInCore.State()
    }
    
    enum Action: Equatable {
        // Child Action
        case signInAction(SignInCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        
        Scope(state: \.signInState, action: /Action.signInAction) {
            SignInCore()
        }
    }
}
