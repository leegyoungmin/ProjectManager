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
            
        }
        .sheet(
            isPresented: ViewStore(store).binding(
                get: \.isPresentDetail,
                send: ._dismissDetail
            )
        ) {
            IfLetStore(
                store.scope(
                    state: \.selectedProject,
                    action: BoardListCore.Action.detailCoreAction
                )
            ) { store in
                DetailProjectView(store: store)
            }
        }
        .onDrop(of: Project.Wrapper.readableTypes, isTargeted: nil) {
            appendProviders(with: $0)
            return true
        }
        .onAppear {
            ViewStore(store).send(.onAppear)
        }
    }
}

private extension BoardListView {
    var listSection: some View {
        List {
            WithViewStore(store) { viewStore in
                ForEach(viewStore.projects, id: \.id) { project in
                    BoardListCellView(with: project)
                        .onDrag { project.provider }
                        .onTapGesture { viewStore.send(.presentProject(project)) }
                }
                .onInsert(of: Project.Wrapper.readableTypes) { appendProviders(with: $1) }
                .onDelete { viewStore.send(.deleteProject($0)) }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    func appendProviders(with providers: [NSItemProvider]) {
        providers.reversed().loadItems(Project.self) { project, error in
            if let project = project {
                DispatchQueue.main.async {
                    ViewStore(store).send(.appendProject(project))
                }
            }
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
