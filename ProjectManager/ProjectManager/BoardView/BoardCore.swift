////
////  BoardCore.swift
////  ProjectManager
////
////  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct BoardCore: ReducerProtocol {
    struct State: Equatable {
        var todoListState = BoardListCore.State(projectState: .todo)
        var doingListState = BoardListCore.State(projectState: .doing)
        var doneListState = BoardListCore.State(projectState: .done)
    }
    
    enum Action: Equatable {
        // Child Action
        case todoAction(BoardListCore.Action)
        case doingAction(BoardListCore.Action)
        case doneAction(BoardListCore.Action)
        
        // Inner Action
        case _fetchResponse(ProjectState, TaskResult<[Assignment]>)
    }
    
    @Dependency(\.coreDataClient) var coreDataClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .todoAction(._deleteAssignResponse):
                return .concatenate(
                    .task {
                        await ._fetchResponse(
                            .doing,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.doing)
                            }
                        )
                    },
                    .task {
                        await ._fetchResponse(
                            .done,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.done)
                            }
                        )
                    }
                )
                
            case .todoAction:
                return .none
                
            case .doingAction(._deleteAssignResponse):
                return .concatenate(
                    .task {
                        await ._fetchResponse(
                            .todo,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.todo)
                            }
                        )
                    },
                    .task {
                        await ._fetchResponse(
                            .done,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.done)
                            }
                        )
                    }
                )
                
            case .doingAction:
                return .none
                
            case .doneAction(._deleteAssignResponse):
                return .concatenate(
                    .task {
                        await ._fetchResponse(
                            .todo,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.todo)
                            }
                        )
                    },
                    .task {
                        await ._fetchResponse(
                            .doing,
                            TaskResult {
                                try await coreDataClient.loadAssignments(.doing)
                            }
                        )
                    }
                )
                
            case .doneAction:
                return .none
                
            case ._fetchResponse(.todo, .success(let assignments)):
                state.todoListState.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._fetchResponse(.doing, .success(let assignments)):
                state.doingListState.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._fetchResponse(.done, .success(let assignments)):
                state.doneListState.projects = assignments.map { $0.convertProject() }
                return .none
                
            case ._fetchResponse(_, .failure):
                return .none
            }
        }
        
        Scope(state: \.todoListState, action: /Action.todoAction) {
            BoardListCore()
        }
        
        Scope(state: \.doingListState, action: /Action.doingAction) {
            BoardListCore()
        }
        
        Scope(state: \.doneListState, action: /Action.doneAction) {
            BoardListCore()
        }
    }
}
