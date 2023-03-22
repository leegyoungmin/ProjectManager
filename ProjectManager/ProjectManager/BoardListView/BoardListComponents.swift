//
//  BoardListView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct BoardListSectionHeader: View {
    let viewStore: ViewStoreOf<BoardListCore>
    
    var body: some View {
        HStack {
            Text(viewStore.projectState.description)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.accentColor)
            
            Spacer()
            
            Text(viewStore.projects.count.description)
                .font(.title)
                .foregroundColor(.black)
                .bold()
                .padding()
                .background(
                    Circle()
                        .fill(.white)
                )
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
}

struct BoardListCellView: View {
    let project: Project
    
    init(with project: Project) {
        self.project = project
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(project.title)
                    .font(.title)
                    .bold()
                    .lineLimit(1)
                
                Text(project.description)
                    .lineLimit(3)
                    .font(.body)
                
                Text(project.date.onlyDate())
                    .lineLimit(1)
                    .font(.footnote)
                    .foregroundColor(project.dateColor)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
}
