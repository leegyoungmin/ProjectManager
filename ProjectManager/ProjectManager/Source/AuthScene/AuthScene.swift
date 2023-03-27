//
//  AuthScene.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct AuthScene: View {
    let store: StoreOf<AuthCore>
    
    var body: some View {
        SignInView(
            store: store.scope(
                state: \.signInState,
                action: AuthCore.Action.signInAction
            )
        )
        .sheet(
            isPresented: ViewStore(store).binding(
                get: \.isPresentSignUp,
                send: ._presentSignUp(false)
            )
        ) {
            IfLetStore(
                store.scope(
                    state: \.signUpState,
                    action: AuthCore.Action.signUpAction
                )
            ) { store in
                SignUpView(store: store)
            }
            .interactiveDismissDisabled()
        }
    }
}

struct AuthScene_Previews: PreviewProvider {
    static let store = Store(
        initialState: AuthCore.State(),
        reducer: AuthCore()
    )
    
    static var previews: some View {
        AuthScene(store: store)
    }
}
