//
//  SignUpCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct SignUpCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""
        @BindingState var confirmPassword: String = ""
        var isCorrect: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$confirmPassword):
                let password = state.password
                let confirm = state.confirmPassword
                state.isCorrect = (password == confirm)
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
