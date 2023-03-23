//
//  BoardListView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct BoardListView: View {
    let store: StoreOf<BoardListCore>
    
    var body: some View {
        VStack(spacing: 30) {
            BoardListSectionHeader(viewStore: ViewStore(store))
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                WithViewStore(store) { viewStore in
                    ForEach(viewStore.projects, id: \.id) { project in
                        BoardListCellView(with: project)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            ViewStore(store).send(.onAppear)
        }
    }
}

struct BoardListView_Previews: PreviewProvider {
    static let store = Store(
        initialState: BoardListCore.State(projectState: .todo),
        reducer: BoardListCore()
    )
    
    static var previews: some View {
        BoardListView(store: store)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewLayout(.device)
    }
}
