//
//  DetailCore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import Foundation
import ComposableArchitecture
import SwiftUI

struct DetailProjectCore: ReducerProtocol {
    struct State: Equatable {
        var id: UUID = UUID()
        @BindingState var title: String = ""
        @BindingState var body: String = ""
        @BindingState var deadLineDate: Date = Date()
        @BindingState var projectState: ProjectState = .todo
        var editMode: EditMode = .active
        
        init(project: Project? = nil) {
            if let project = project {
                self.id = project.id
                self.title = project.title
                self.body = project.description
                self.deadLineDate = project.date
                self.projectState = project.state
                self.editMode = .inactive
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        // User Action
        case tapEditButton(Bool)
        case tapSaveButton
        
        // Inner Action
        case _editModeToActive
        case _editModeToInactive
        case _saveProjectResponse(TaskResult<Bool>)
        
        // Binding Action
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.projectsClient) var projectsClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tapEditButton(true):
                return .run { await $0.send(._editModeToActive) }
            case .tapEditButton(false):
                return .run { await $0.send(._editModeToInactive) }

            case .tapSaveButton:
                
                let project = Project(
                    id: state.id,
                    title: state.title,
                    date: state.deadLineDate,
                    description: state.body,
                    state: state.projectState
                )
                return .task {
                    await ._saveProjectResponse(
                        TaskResult {
                            try await projectsClient.saveProject(project)
                        }
                    )
                }
            case ._editModeToActive:
                state.editMode = .active
                return .none
                
            case ._editModeToInactive:
                state.editMode = .inactive
                return .none
                
            case ._saveProjectResponse(.success):
                return .none
                
            case ._saveProjectResponse:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
