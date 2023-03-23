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
        @BindingState var title: String = ""
        @BindingState var body: String = ""
        @BindingState var deadLineDate: Date = Date()
        var editMode: EditMode = .inactive
    }
    
    enum Action:BindableAction, Equatable {
        // User Action
        case tapEditButton(Bool)
        case tapSaveButton
        
        // Inner Action
        case _editModeToActive
        case _editModeToInactive
        
        // Binding Action
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tapEditButton(true):
                return .task {
                    ._editModeToActive
                }
            case .tapEditButton(false):
                return .task {
                    ._editModeToInactive
                }
                
            case .tapSaveButton:
                // TODO: - Remote Server 저장 및 데이터 저장 메서드 추가
                print("Save Button Tapped")
                return .none
                
            case ._editModeToActive:
                state.editMode = .active
                return .none
                
            case ._editModeToInactive:
                state.editMode = .inactive
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
