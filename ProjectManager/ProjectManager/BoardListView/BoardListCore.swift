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
    
    @Dependency(\.coreDataClient) var coreDataClient
    
    enum Action: Equatable {
        case onAppear
        case appendProject(Project)
        
        case _assignLoadResponse(TaskResult<[Assignment]>)
        case _saveAssignResponse(TaskResult<Bool>)
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
                }
                
            case .appendProject(let project):
                var project = project
                project.state = state.projectState
                
                return .task { [project = project] in
                    await ._saveAssignResponse(
                        TaskResult {
                            try await coreDataClient.addAssignment(project)
                        }
                    )
                }
                
            case let ._assignLoadResponse(.success(assignments)):
                state.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._assignLoadResponse(.failure):
                return .none
                
            case ._saveAssignResponse(.success):
                return .run {
                    await $0.send(.onAppear)
                }
                
            case ._saveAssignResponse(.failure):
                return .none
            }
        }
    }
}
