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
        var signUpState: SignUpCore.State?
    }
    
    enum Action: Equatable {
        // User Action
        // Inner Action
        // Child Action
        case signInAction(SignInCore.Action)
        case signUpAction(SignUpCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .signInAction(.signUp):
                state.signUpState = SignUpCore.State()
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.signUpState, action: /Action.signUpAction) {
            SignUpCore()
        }
        
        Scope(state: \.signInState, action: /Action.signInAction) {
            SignInCore()
        }
    }
}
