//
//  BoardView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct BoardView: View {
  let store: Store<BoardState, BoardAction>
  var body: some View {
    HStack {
      BoardListView(
        store: store.scope(
          state: \.todoListState,
          action: BoardAction.todoListAction
        )
      )
      
      BoardListView(
        store: store.scope(
          state: \.doingListState,
          action: BoardAction.doingListAction
        )
      )
      
      BoardListView(
        store: store.scope(
          state: \.doneListState,
          action: BoardAction.doneListAction
        )
      )
    }
  }
}

struct BoardView_Previews: PreviewProvider {
  static let store = Store(
    initialState: BoardState(),
    reducer: boardReducer,
    environment: BoardEnvironment()
  )
  
  static var previews: some View {
    BoardView(store: store)
  }
}
