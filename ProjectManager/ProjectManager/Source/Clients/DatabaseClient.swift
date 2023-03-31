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
    var setAuthValues: @Sendable () async throws -> Bool
    var setProjectValue: @Sendable (Project) async throws -> Bool
    var deleteProjectValue: @Sendable (Project) async throws -> Bool
}

extension DatabaseClient {
    enum DatabaseError: Error {
        case invalidUser
        case setValueError
        case deleteValueError
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
        setAuthValues: {
            guard let user = Auth.auth().currentUser,
                  let email = user.email else {
                throw DatabaseError.invalidUser
            }
            
            let store = Firestore.firestore()
            var document = store.collection("Users").document(user.uid)
            let userInformation = UserInformation(userId: user.uid, email: email)
            guard let result = try? document.setData(from: userInformation) else {
                throw DatabaseError.setValueError
            }
            
            return true
        },
        setProjectValue: { project in
            guard let currentUser = Auth.auth().currentUser else {
                throw DatabaseError.invalidUser
            }
            let store = Firestore.firestore()
            let authDocument = store.collection("Users").document(currentUser.uid)
            let document = store.collection("Projects").document(project.id.uuidString)
            
            guard let result = try? document.setData(from: project) else {
                throw DatabaseError.setValueError
            }
            
            authDocument.updateData([
                "projectIds": FieldValue.arrayUnion([project.id.uuidString])
            ])
            
            return true
        },
        deleteProjectValue: { project in
            guard let currentUser = Auth.auth().currentUser else {
                throw DatabaseError.invalidUser
            }
            
            let store = Firestore.firestore()
            let authDocument = store.collection("Users").document(currentUser.uid)
            let document = store.collection("Projects").document(project.id.uuidString)
            
            document.delete()
            
            authDocument.updateData([
                "projectIds": FieldValue.arrayRemove([project.id.uuidString])
            ])
            
            return true
        }
    )
}
