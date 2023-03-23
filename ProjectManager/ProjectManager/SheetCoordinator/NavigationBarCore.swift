//
//  NavigationStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation

struct NavigationBarCore: ReducerProtocol {
    struct State: Equatable {
        var isPresent: Bool = false
        var title: String = "Project Manager"
        var detailState: DetailProjectCore.State?
    }
    
    enum Action: Equatable {
        // User Action
        case didTapPresent(Bool)
        
        // Inner Action
        case _setIsPresent
        case _setIsNotPresent
        
        // Child Action
        case detailAction(DetailProjectCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapPresent(true):
                return .task {
                    ._setIsPresent
                }
                
            case .didTapPresent(false):
                return .task {
                    ._setIsNotPresent
                }
                
                // Inner Action
            case ._setIsPresent:
                state.isPresent = true
                state.detailState = DetailProjectCore.State()
                return .none
                
            case ._setIsNotPresent:
                state.isPresent = false
                return .none
                
            case .detailAction(.tapSaveButton):
                print("Tapped Save Button")
                return .none
                
            case .detailAction:
                return .none
            }
        }
        .ifLet(\.detailState, action: /Action.detailAction) {
            DetailProjectCore()
        }
    }
}
