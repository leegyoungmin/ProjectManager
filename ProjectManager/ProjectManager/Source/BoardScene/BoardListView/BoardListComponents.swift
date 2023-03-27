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
            VStack(alignment: .leading) {
                Text(project.title)
                    .font(.title)
                    .bold()
                    .lineLimit(1)
                    .padding(.bottom, 5)
                
                Text(project.description)
                    .lineLimit(2)
                    .font(.body)
                
                Text(project.date.onlyDate())
                    .lineLimit(1)
                    .font(.footnote)
                    .foregroundColor(project.dateColor)
            }
            .padding()
            
            Spacer()
        }
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
}

struct BoardListComponents_Previews: PreviewProvider {
    static let project = Project.mockData.first!
    
    static var previews: some View {
        Group {
            BoardListCellView(with: project)
                .previewLayout(.sizeThatFits)
        }
    }
}
