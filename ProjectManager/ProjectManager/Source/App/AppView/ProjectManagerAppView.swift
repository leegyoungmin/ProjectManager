//
//  ProjectManagerAppView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ProjectManagerAppView: View {
    let store = Store(initialState: AppCore.State(), reducer: AppCore()._printChanges())
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.user == nil {
                AuthScene(
                    store: store.scope(
                        state: \.authState,
                        action: AppCore.Action.authAction
                    )
                )
            }
            
            IfLetStore(
                store.scope(
                    state: \.boardSceneState,
                    action: AppCore.Action.boardSceneAction
                )
            ) { store in
                BoardScene(store: store)
            }
        }
    }
}
