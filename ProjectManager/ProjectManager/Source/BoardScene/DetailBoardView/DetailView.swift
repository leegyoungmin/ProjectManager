//
//  EditView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct DetailProjectView: View {
    let store: StoreOf<DetailProjectCore>
    
    init(store: StoreOf<DetailProjectCore>) {
        self.store = store
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    titleTextFieldSection
                    
                    deadLineDatePickerSection
                    
                    bodyTextEditorSection
                }
                .padding()
                .background(Color.secondaryBackground)
                .navigationTitle(viewStore.projectState.description)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        leadingEditButton
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        trailingSaveButton
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}

// MARK: - Edit Components
private extension DetailProjectView {
    var titleTextFieldSection: some View {
        WithViewStore(store) { viewStore in
            TextField("Title", text: viewStore.binding(\.$title))
                .detailItemStyle()
                .disabled(viewStore.editMode == .inactive)
        }
    }
    
    var deadLineDatePickerSection: some View {
        WithViewStore(store) { viewStore in
            DatePicker(
                "마감 기한",
                selection: viewStore.binding(\.$deadLineDate),
                in: Date()...,
                displayedComponents: .date
            )
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .detailItemStyle()
            .disabled(viewStore.editMode == .inactive)
        }
    }
    
    var bodyTextEditorSection: some View {
        WithViewStore(store) { viewStore in
            TextEditor(text: viewStore.binding(\.$body))
                .detailItemStyle()
                .disabled(viewStore.editMode == .inactive)
        }
    }
}

// MARK: - Navigation Bar Button Items
private extension DetailProjectView {
    var leadingEditButton: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.editMode {
            case .inactive:
                editButton
                
            case .active:
                confirmButton
            default:
                EmptyView()
            }
        }
    }
    
    var trailingSaveButton: some View {
        WithViewStore(store) { viewStore in
            Button {
                ViewStore(store).send(.tapSaveButton)
            } label: {
                Text("저장")
            }
            
            // TODO: - Disable 메서드 적용
        }
    }
    
    var editButton: some View {
        Button("수정") {
            ViewStore(store).send(.tapEditButton(true))
        }
    }
    
    var confirmButton: some View {
        Button("완료") {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
            
            ViewStore(store).send(.tapEditButton(false))
        }
    }
}

private struct DetailItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 1, y: 1)
    }
}

private extension View {
    func detailItemStyle() -> some View {
        modifier(DetailItemModifier())
    }
}

struct DetailView_Previews: PreviewProvider {
    static let store = Store(initialState: DetailProjectCore.State(), reducer: DetailProjectCore())
    static var previews: some View {
        DetailProjectView(store: store)
            .previewLayout(.fixed(width: 1000, height: 1200))
            .padding()
    }
}
