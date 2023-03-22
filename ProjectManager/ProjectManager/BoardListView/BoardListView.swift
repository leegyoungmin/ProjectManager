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

/*
 WithViewStore(store) { viewStore in
 VStack(spacing: 10) {
 BoardListSectionHeader(
 projectState: viewStore.status,
 count: viewStore.projects.count
 )
 .padding()
 
 Divider()
 .frame(height: 2)
 .background(Color.accentColor)
 .padding(.horizontal)
 .cornerRadius(10)
 
 
 List(viewStore.projects, id: \.id) { project in
 BoardListCellView(project: project)
 .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
 .listRowSeparator(.hidden)
 .swipeActions(edge: .trailing, allowsFullSwipe: true) {
 Button("DELETE") {
 viewStore.send(.tapDelete(project))
 }
 .tint(.red)
 }
 .onTapGesture {
 viewStore.send(.tapDetailShow(project))
 }
 .contextMenu {
 switch viewStore.status {
 case .todo:
 Button("DOING") {
 viewStore.send(.movingToDoing(project))
 }
 
 Button("DONE") {
 viewStore.send(.movingToDone(project))
 }
 
 case .doing:
 Button("TODO") {
 viewStore.send(.movingToTodo(project))
 }
 
 Button("DONE") {
 viewStore.send(.movingToDone(project))
 }
 
 case .done:
 Button("TODO") {
 viewStore.send(.movingToTodo(project))
 }
 
 Button("DOING") {
 viewStore.send(.movingToDoing(project))
 }
 }
 }
 .sheet(
 item: viewStore.binding(
 get: \.selectedProject,
 send: ._dismissItem
 )
 ) { store in
 //              IfLetStore(
 //                self.store.scope(
 //                  state: \.selectedProject,
 //                  action: BoardListAction.detailAction
 //                )
 //              ) { store in
 //                ProjectDetailView(store: store)
 //              }
 }
 }
 .listStyle(.plain)
 .onAppear {
 viewStore.send(._onAppear)
 }
 }
 }
 
 */
