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
        
        case _AssignLoadResponse(TaskResult<[Assignment]>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task { [status = state.projectState] in
                    await ._AssignLoadResponse(
                        TaskResult {
                            try await coreDataClient.loadAssignments(status)
                        }
                    )
                }
            case let ._AssignLoadResponse(.success(assignments)):
                state.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._AssignLoadResponse(.failure):
                return .none
            }
        }
    }
}
