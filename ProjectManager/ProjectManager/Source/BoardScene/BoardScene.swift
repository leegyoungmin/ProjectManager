//
//  BoardScene.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct BoardScene: View {
    let store: StoreOf<BoardSceneCore>
    
    var body: some View {
        VStack(spacing: 30) {
            NavigationBarView(
                navigationStore: store.scope(
                    state: \.navigationBarState,
                    action: BoardSceneCore.Action.navigationBarAction
                )
            )

            BoardView(
                store: store.scope(
                    state: \.boardState,
                    action: BoardSceneCore.Action.boardAction
                )
            )
            .onChange(of: ViewStore(store).navigationBarState.isPresent) {
                if $0 == false {
                    ViewStore(store).send(.boardAction(.reloadData))
                }
            }
        }
    }
}
