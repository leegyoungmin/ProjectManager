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
            List {
                WithViewStore(store) { viewStore in
                    ForEach(viewStore.projects, id: \.id) { project in
                        BoardListCellView(with: project)
                            .onDrag {
                                project.provider
                            }
                    }
                    .onInsert(of: Project.Wrapper.readableTypes) { index, providers in
                        providers.reversed().loadItems(Project.self) { project, error in
                            if let project = project {
                                DispatchQueue.main.async {
                                    viewStore.send(.appendProject(project))
                                }
                            }
                        }
                    }
                    .onDelete { index in
                        viewStore.send(.deleteProject(index))
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .onDrop(of: Project.Wrapper.readableTypes, isTargeted: nil) { providers, location in
            providers.reversed().loadItems(Project.self) { project, error in
                if let project = project {
                    DispatchQueue.main.async {
                        ViewStore(store).send(.appendProject(project))
                    }
                }
            }
            
            return true
        }
        .onAppear {
            ViewStore(store).send(.onAppear)
        }
    }
}

struct BoardListView_Previews: PreviewProvider {
    static let store = Store(
        initialState: BoardListCore.State(
            projectState: .doing,
            projects: Project.mockData
        ),
        reducer: BoardListCore()
    )
    
    static var previews: some View {
        BoardListView(store: store)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewLayout(.device)
    }
}
