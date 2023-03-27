//
//  AuthClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift

struct AuthClient {
    var authRequest: @Sendable (_ id: String, _ password: String) async throws -> User
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

extension AuthClient: DependencyKey {
    enum AuthError: Error {
        case loginError
    }
    
    static let liveValue = AuthClient(
        authRequest: { email, password in
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
            
            guard let result = result else {
                throw AuthError.loginError
            }
            
            return result.user
        }
    )
}