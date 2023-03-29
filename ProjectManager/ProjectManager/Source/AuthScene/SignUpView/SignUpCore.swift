//
//  SignUpCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct SignUpCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""
        @BindingState var confirmPassword: String = ""
        
        var isValidEmail: Bool = false
        var isValidPassword: Bool = false
        var isCorrect: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        // User Action
        case signUp
        case binding(BindingAction<State>)
        
        // Inner Action
        case _signUpResponse(TaskResult<User>)
        case _setDatabaseResponse(TaskResult<DatabaseReference>)
    }
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$email):
                let email = state.email
                state.isValidEmail = validEmail(emailValue: email)
                return .none
                
            case .binding(\.$password):
                let password = state.password
                state.isValidPassword = validPassword(passwordValue: password)
                return .none
                
            case .binding(\.$confirmPassword):
                let password = state.password
                let confirm = state.confirmPassword
                
                state.isCorrect = (password == confirm)
                return .none
                
            case .binding:
                return .none
                
            case .signUp:
                return .task { [email = state.email, password = state.password] in
                    await ._signUpResponse(
                        TaskResult {
                            try await authClient.signUp(email, password)
                        }
                    )
                }
                
            case let ._signUpResponse(.success(user)):
                return .task { [user = user] in
                    await ._setDatabaseResponse(
                        TaskResult {
                            try await databaseClient.setValues(
                                ["User", "\(user.uid)"],
                                ["email": user.email as Any]
                            )
                        }
                    )
                }
                
            case ._signUpResponse(.failure):
                return .none
                
            case ._setDatabaseResponse:
                return .none
            }
        }
    }
    
    func validEmail(emailValue: String) -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return predicate.evaluate(with: emailValue)
    }
    
    func validPassword(passwordValue: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: passwordValue)
    }
}
