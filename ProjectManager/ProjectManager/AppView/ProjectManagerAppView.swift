//
//  ProjectManagerAppView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import SwiftUI
import ComposableArchitecture

struct ProjectManagerAppView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    VStack {
      NavigationBarView(
        navigationStore: self.store.scope(
          state: \.sheetState,
          action: AppAction.sheetAction
        )
      )
      BoardView(
        store: self.store.scope(
          state: \.boardState,
          action: AppAction.boardAction
        )
      )
    }
  }
}
