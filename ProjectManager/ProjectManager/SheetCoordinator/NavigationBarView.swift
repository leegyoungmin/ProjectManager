//
//  NavigationBarView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
    let navigationStore: StoreOf<NavigationBarCore>
    
    var body: some View {
        HStack {
            Spacer()
            
            WithViewStore(
                navigationStore.scope(state: \.title)
            ) {
                Text($0.state)
                    .foregroundColor(.accentColor)
                    .textFont(size: 28, weight: .bold)
            }
            
            Spacer()
            
            WithViewStore(navigationStore) { viewStore in
                Button {
                    viewStore.send(.didTapPresent(true))
                } label: {
                    Image(systemName: "plus")
                        .textFont(size: 28, weight: .bold)
                }
                .sheet(isPresented: viewStore.binding(get: \.isPresent, send: ._setIsNotPresent)) {
                    Text("Example")
                }
            }
        }
        .padding()
        .background(.ultraThickMaterial)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static let store = Store(
        initialState: NavigationBarCore.State(),
        reducer: NavigationBarCore()
    )
    
    static var previews: some View {
        NavigationBarView(navigationStore: store)
    }
}
