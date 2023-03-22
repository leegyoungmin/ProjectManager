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
            
            HStack {
                ForEach(ProjectState.allCases, id: \.rawValue) { state in
                    BoardListView(
                        store: Store(
                            initialState: BoardListCore.State(projectState: state),
                            reducer: BoardListCore()
                        )
                    )
                }
            }
        }
    }
}
