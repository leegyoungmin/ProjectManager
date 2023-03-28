//
//  DatabaseClients.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import FirebaseDatabase
import FirebaseDatabaseSwift

struct DatabaseClient {
    var uploadData: @Sendable ([String], Dictionary<String, Any>) async throws -> DatabaseReference
}

extension DatabaseClient {
    enum DatabaseError: Error {
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
        uploadData: { keys, values in
            var reference = Database.database().reference()
            keys.forEach {
                reference = reference.child($0)
            }
            
            let ref = try? await reference.setValue(values)
            
            guard let ref = ref else { throw DatabaseError.setValueError }
            
            return ref
        }
    )
}
