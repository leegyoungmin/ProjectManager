//
//  SignUpView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct SignUpView: View {
    let store: StoreOf<SignUpCore>
    var body: some View {
        VStack {
            Text("Example")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static let store = Store(initialState: SignUpCore.State(), reducer: SignUpCore())
    static var previews: some View {
        SignUpView(store: store)
    }
}
