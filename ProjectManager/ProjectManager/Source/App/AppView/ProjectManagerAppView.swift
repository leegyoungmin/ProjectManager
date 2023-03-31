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
            VStack(spacing: .zero) {
                NoNetworkView()
                    .environmentObject(NetworkMonitor.shared)
                    .background(Color.secondaryBackground)
                
                if viewStore.user == nil {
                    AuthScene(
                        store: store.scope(
                            state: \.authState,
                            action: AppCore.Action.authAction
                        )
                    )
                }
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

extension ProjectManagerAppView {
    struct NoNetworkView: View {
        @EnvironmentObject var monitor: NetworkMonitor
        var body: some View {
            if monitor.isConnected == false {
                HStack {
                    Spacer()
                    Label("네트워크 연결이 끊겼습니다. 확인해주세요.", image: "wifi.slash")
                    Spacer()
                }
                .padding(.bottom)
            }
        }
    }
}
