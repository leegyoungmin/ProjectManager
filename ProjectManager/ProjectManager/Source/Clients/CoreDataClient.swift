//
//  CoreDataClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct CoreDataClient {
    var loadAssignments: @Sendable (ProjectState) async throws -> [Assignment]
    var addAssignment: @Sendable (Project) async throws -> Bool
    var deleteAssignment: @Sendable (Project) async throws -> Bool
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
            return CoreDataManager.shared.loadAssignments(state: $0)
        },
        addAssignment: {
            return CoreDataManager.shared.saveProject(with: $0)
        },
        deleteAssignment: {
            return CoreDataManager.shared.deleteProject(with: $0)
        }
    )
}
