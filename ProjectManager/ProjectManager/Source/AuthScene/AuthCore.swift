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
        // User Action
        // Child Action
        case signInAction(SignInCore.Action)
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.signInState, action: /Action.signInAction) {
            SignInCore()
        }
    }
}
