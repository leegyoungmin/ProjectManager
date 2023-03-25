//
//  AuthClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift

struct AuthClient {
    var authRequest: @Sendable (_ id: String, _ password: String) async throws -> Bool
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

extension AuthClient: DependencyKey {
    static var user: User?
    
    static let liveValue = AuthClient(
        authRequest: { email, password in
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
            
            guard let result = result else { return false }
            
            Self.user = result.user
            return true
        }
    )
}
