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
    
    @Dependency(\.databaseClient) var databaseClient
    @Dependency(\.coreDataClient) var coreDataClient
    
    enum Action: Equatable {
        // User Action
        case onAppear
        case appendProject(Project)
        case deleteProject(IndexSet)
        
        // Inner Action
        case _saveProject(Project)
        case _deleteProject(Project)
        
        case _assignLoadResponse(TaskResult<[Assignment]>)
        case _saveAssignResponse(TaskResult<Project>)
        case _deleteAssignResponse(TaskResult<Bool>)
        
        case _saveProjectStoreResponse(TaskResult<Bool>)
        case _deleteProjectStoreResponse(TaskResult<Bool>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task { [status = state.projectState] in
                    await ._assignLoadResponse(
                        TaskResult {
                            try await coreDataClient.loadAssignments(status)
                        }
                    )
                }.animation()
                
            case .appendProject(let project):
                var newProject = project
                newProject.id = UUID()
                newProject.state = state.projectState
                
                return .concatenate(
                    .run { [newProject = newProject] in
                        await $0.send(._saveProject(newProject))
                    },
                    .run { await $0.send(._deleteProject(project))}
                )
                
            case let .deleteProject(index):
                guard let firstIndex = index.first else { return .none }
                let project = state.projects[firstIndex]
                return .task {
                    ._deleteProject(project)
                }
                
            case let ._saveProject(project):
                return .concatenate(
                    .task { [project = project] in
                        await ._saveProjectStoreResponse(
                            TaskResult {
                                try await databaseClient.setProjectValue(project)
                            }
                        )
                    },
                    .task { [project = project] in
                        await ._saveAssignResponse(
                            TaskResult {
                                try await coreDataClient.addAssignment(project)
                            }
                        )
                    }
                )
                
            case let ._deleteProject(project):
                return .concatenate(
                    .task { [project = project] in
                        await ._deleteProjectStoreResponse(
                            TaskResult {
                                try await databaseClient.deleteProjectValue(project)
                            }
                        )
                    },
                    .task { [project = project] in
                        await ._deleteAssignResponse(
                            TaskResult {
                                try await coreDataClient.deleteAssignment(project)
                            }
                        )
                    }
                )
                
            case let ._assignLoadResponse(.success(assignments)):
                state.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._assignLoadResponse(.failure):
                return .none
                
            case ._saveAssignResponse(.success):
                return .run { await $0.send(.onAppear) }
                
            case ._saveAssignResponse(.failure):
                return .none
                
            default:
                return .none
            }
        }
    }
}
