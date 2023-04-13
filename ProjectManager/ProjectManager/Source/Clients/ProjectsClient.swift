//
//  ProjectsClient.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProjectsClient {
    var loadProjects: @Sendable (ProjectState) async throws -> [Project]
    var deleteProject: @Sendable (Project) async throws -> Bool
    var saveProject: @Sendable (Project) async throws -> Bool
}

extension DependencyValues {
    var projectsClient: ProjectsClient {
        get { self[ProjectsClient.self] }
        set { self[ProjectsClient.self] = newValue }
    }
}

extension ProjectsClient: DependencyKey {
    static var liveValue = ProjectsClient(
        loadProjects: { state in
            return await ProjectProvider.shared.loadProjects(with: state)
        },
        deleteProject: { project in
            return await ProjectProvider.shared.deleteProject(with: project)
        },
        saveProject: { project in
            return await ProjectProvider.shared.saveProject(with: project)
        }
    )
}
