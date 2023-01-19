//
//  NavigationBarView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
  let navigationStore: Store<SheetState, SheetAction>
  
  var body: some View {
    WithViewStore(navigationStore) { viewStore in
      ZStack {
        HStack {
          Spacer()
          
          Text(viewStore.title)
            .foregroundColor(.accentColor)
            .customTitleStyle()
          
          Spacer()
        }
        
        HStack {
          Spacer()
          
          Button {
            viewStore.send(.didTapPresent(true))
          } label: {
            Image(systemName: "plus")
              .customTitleStyle()
          }
        }
        .padding([.vertical, .trailing])
      }
      .background(Color.secondaryBackground)
      .sheet(
        isPresented: viewStore.binding(
          get: \.isPresent,
          send: SheetAction.didTapPresent
        )
      ) {
        IfLetStore(
          self.navigationStore.scope(
            state: \.detailState,
            action: SheetAction.detailAction
          )
        ) { viewStore in
          ProjectDetailView(store: viewStore)
        }
      }
    }
  }
}

struct NavigationBarView_Previews: PreviewProvider {
  static let store = Store(
    initialState: SheetState(),
    reducer: sheetReducer,
    environment: SheetEnvironment()
  )
  
  static var previews: some View {
    NavigationBarView(navigationStore: store)
  }
}