//
//  AuthClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth

struct AuthClient {
    var signIn: @Sendable (_ id: String, _ password: String) async throws -> User
    var signUp: @Sendable (_ email: String, _ password: String) async throws -> User
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
        case signUpError
        case setDatabaseError
    }
    
    static let liveValue = AuthClient(
        signIn: { email, password in
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
            
            guard let result = result else {
                throw AuthError.loginError
            }
            
            return result.user
        },
        signUp: { email, password in
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return signInResult.user
        }
    )
}
