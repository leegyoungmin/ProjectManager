//
//  SignUpCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation

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
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$email):
                let email = state.email
                state.isValidEmail = validEmail(emailValue: email)
                return .none
                
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
    
    func validEmail(emailValue: String) -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return predicate.evaluate(with: emailValue)
    }
    
    func validPassword(passwordValue: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: passwordValue)
    }
}
