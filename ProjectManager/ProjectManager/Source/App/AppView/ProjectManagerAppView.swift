//
//  ProjectManagerAppView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ProjectManagerAppView: View {
    let store = Store(initialState: AppCore.State(), reducer: AppCore())
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.user == nil {
                AuthScene(
                    store: store.scope(
                        state: \.authState,
                        action: AppCore.Action.authAction
                    )
                )
            } else {
                VStack(spacing: 30) {
                    NavigationBarView(
                        navigationStore: store.scope(
                            state: \.navigationBarState,
                            action: AppCore.Action.navigationBarAction
                        )
                    )

                    BoardView(
                        store: store.scope(
                            state: \.boardState,
                            action: AppCore.Action.boardAction
                        )
                    )
                    .onChange(of: viewStore.navigationBarState.isPresent) {
                        if $0 == false {
                            viewStore.send(.boardAction(.reloadData))
                        }
                    }
                }
            }
        }
    }
}
