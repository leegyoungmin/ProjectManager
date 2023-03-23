//
//  CoreDataClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct CoreDataClient {
    var loadAssignments: @Sendable () async throws -> [Assignment]
}

extension DependencyValues {
    var coreDataClient: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}

extension CoreDataClient: DependencyKey {
    static let liveValue = CoreDataClient(
        loadAssignments: {
            return CoreDataManager.shared.loadAssignments()
        }
    )
}
