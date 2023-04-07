//
//  BoardListState.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture
import SwiftUI

struct BoardListCore: ReducerProtocol {
    struct State: Equatable {
        let projectState: ProjectState
        var projects: [Project]
        
        init(projectState: ProjectState, projects: [Project] = []) {
            self.projectState = projectState
            self.projects = projects
        }
    }
    
    @Dependency(\.projectsClient) var projectsClient
    
    enum Action: Equatable {
        // User Action
        case onAppear
        case appendProject(Project)
        case deleteProject(IndexSet)
        
        // Inner Action
        case _saveProject(Project)
        
        case _projectLoadResponse(TaskResult<[Project]>)
        
        case _saveProjectResponse(TaskResult<Bool>)
        case _deleteProjectResponse(TaskResult<Bool>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task { [state = state.projectState] in
                    await ._projectLoadResponse(
                        TaskResult {
                            try await projectsClient.loadProjects(state)
                        }
                    )
                }
                .animation()
                
            case .appendProject(let project):
                var newProject = project
                newProject.id = UUID()
                newProject.state = state.projectState
                
                return .concatenate(
                    .run { [newProject = newProject] in
                        await $0.send(._saveProject(newProject))
                    },
                    .task { [project = project] in
                        await ._deleteProjectResponse(
                            TaskResult {
                                try await projectsClient.deleteProject(project)
                            }
                        )
                    }
                )
                
            case let .deleteProject(index):
                guard let firstIndex = index.first else { return .none }
                let project = state.projects[firstIndex]
                
                return .task { [project = project] in
                    await ._deleteProjectResponse(
                        TaskResult {
                            try await projectsClient.deleteProject(project)
                        }
                    )
                }
                
            case let ._saveProject(project):
                return .task {
                    await ._saveProjectResponse(
                        TaskResult {
                            try await projectsClient.saveProject(project)
                        }
                    )
                }
                
            case let ._projectLoadResponse(.success(projects)):
                state.projects = projects
                return .none
                
            case ._projectLoadResponse:
                return .none
                
            case ._deleteProjectResponse(.success):
                return .run { await $0.send(.onAppear) }
                
            default:
                return .none
            }
        }
    }
}
