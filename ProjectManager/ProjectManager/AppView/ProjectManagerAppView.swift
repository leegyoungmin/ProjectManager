//
//  ProjectManagerAppView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ProjectManagerAppView: View {
    var body: some View {
        VStack(spacing: 30) {
            NavigationBarView(
                navigationStore: Store(
                    initialState: NavigationBarCore.State(),
                    reducer: NavigationBarCore()._printChanges()
                )
            )
            
            BoardView(
                store: Store(
                    initialState: BoardCore.State(),
                    reducer: BoardCore()._printChanges()
                )
            )
        }
    }
}
