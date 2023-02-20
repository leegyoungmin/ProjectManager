//
//  ProjectManagerApp.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI
import ComposableArchitecture

@main
struct ProjectManagerApp: App {
  let persistenceController = PersistenceController.shared
  let store = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
      coreDataClient: .live,
      mainQueue: .main
    )
  )
  
  var body: some Scene {
    WindowGroup {
      ProjectManagerAppView(store: store)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
