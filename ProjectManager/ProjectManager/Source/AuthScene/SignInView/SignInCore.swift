//
//  SignInCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth

struct SignInCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""
    }
    
    enum Action: BindableAction, Equatable {
        // User Action
        case login
        case signUp
        
        // Inner Action
        case _signInWithEmailAndPassword(TaskResult<User>)
        
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .login:
                return .task { [email = state.email, password = state.password] in
                    await ._signInWithEmailAndPassword(
                        TaskResult {
                            try await authClient.signIn(email, password)
                        }
                    )
                }
                
            case .signUp:
                return .none
                
            case ._signInWithEmailAndPassword:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
