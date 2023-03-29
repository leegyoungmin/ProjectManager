//
//  DatabaseClients.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DatabaseClient {
    var setAuthValues: @Sendable (User) async throws -> Bool
}

extension DatabaseClient {
    enum DatabaseError: Error {
        case invalidUser
        case setValueError
    }
}

extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}

extension DatabaseClient: DependencyKey {
    static var liveValue = DatabaseClient(
        setAuthValues: { user in
            guard let email = user.email else { throw DatabaseError.invalidUser }
            
            let store = Firestore.firestore()
            var document = store.collection("Users").document(user.uid)
            let userInformation = UserInformation(userId: user.uid, email: email)
            guard let result = try? document.setData(from: userInformation) else {
                throw DatabaseError.setValueError
            }
            
            return true
            
        }
    )
}
