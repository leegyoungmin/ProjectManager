//
//  BoardView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct BoardView: View {
    let store: StoreOf<BoardCore>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                BoardListView(
                    store: store.scope(
                        state: \.todoListState,
                        action: BoardCore.Action.todoAction
                    )
                )
                
                BoardListView(
                    store: store.scope(
                        state: \.doingListState,
                        action: BoardCore.Action.doingAction
                    )
                )
                
                BoardListView(
                    store: store.scope(
                        state: \.doneListState,
                        action: BoardCore.Action.doneAction
                    )
                )
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    
    static let store = Store(initialState: BoardCore.State(), reducer: BoardCore())
    
    static var previews: some View {
        BoardView(store: store)
    }
}
