//
//  SignInCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth

struct SignInCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var email: String = "cow970814@naver.com"
        @BindingState var password: String = "km**970814"
        var isPresentSignUpPage: Bool = false
        var signUpState: SignUpCore.State?
    }
    
    enum Action: BindableAction, Equatable {
        // User Action
        case login
        case signUp
        case binding(BindingAction<State>)
        
        // Inner Action
        case _presentSignUpPage(Bool)
        case _signInWithEmailAndPassword(TaskResult<User>)
        
        case signUpAction(SignUpCore.Action)
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
                
            case .binding:
                return .none
                
            case ._presentSignUpPage(let isPresent):
                state.signUpState = SignUpCore.State()
                state.isPresentSignUpPage = isPresent
                return .none
                
            case ._signInWithEmailAndPassword:
                return .none

            case .signUpAction(._signUpResponse(.success)):
                state.isPresentSignUpPage = false
                guard let email = state.signUpState?.email,
                      let password = state.signUpState?.password else {
                    return .none
                }
                return .task { [email = email, password = password] in
                    await ._signInWithEmailAndPassword(
                        TaskResult {
                            try await authClient.signIn(email, password)
                        }
                    )
                }
                
            case .signUpAction:
                return .none
            }
        }
        .ifLet(\.signUpState, action: /Action.signUpAction) {
            SignUpCore()
        }
    }
}
