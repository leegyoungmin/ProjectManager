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
        case reloadData
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
            case .reloadData:
                return .concatenate(
                    .run {
                        await $0.send(.todoAction(.onAppear))
                    },
                    .run {
                        await $0.send(.doingAction(.onAppear))
                    },
                    .run {
                        await $0.send(.doneAction(.onAppear))
                    }
                )
            case .todoAction(._deleteAssignResponse):
                return deleteAssignResponse(types: (.doing, .done)).animation()
                
            case .todoAction:
                return .none
                
            case .doingAction(._deleteAssignResponse):
                return deleteAssignResponse(types: (.todo, .done)).animation()
                
            case .doingAction:
                return .none
                
            case .doneAction(._deleteAssignResponse):
                return deleteAssignResponse(types: (.todo, .doing)).animation()
                
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
    
    func deleteAssignResponse(types: (ProjectState, ProjectState)) -> EffectTask<Action> {
        return .concatenate(
            .task {
                await ._fetchResponse(
                    types.0,
                    TaskResult {
                        try await coreDataClient.loadAssignments(types.0)
                    }
                )
            },
            .task {
                await ._fetchResponse(
                    types.1,
                    TaskResult {
                        try await coreDataClient.loadAssignments(types.1)
                    }
                )
            }
        )
    }
}
