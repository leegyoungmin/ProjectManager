//
//  EditView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ProjectDetailView: View {
    let store: StoreOf<DetailProjectCore>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    TextField("Title", text: viewStore.binding(\.$title))
                        .detailItemStyle()
                        .disabled(viewStore.editMode == .inactive)
                    
                    DatePicker(
                        "마감 기한",
                        selection: viewStore.binding(\.$deadLineDate),
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .detailItemStyle()
                    .disabled(viewStore.editMode == .inactive)
                    
                    TextEditor(
                        text: viewStore.binding(\.$body)
                    )
                    .detailItemStyle()
                    .disabled(viewStore.editMode == .inactive)
                }
                .padding()
                .background(Color.secondaryBackground)
//                .navigationTitle(viewStore.projectStatus.description)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        switch viewStore.editMode {
                        case .inactive:
                            Button("수정") {
                                viewStore.send(.tapEditButton(true))
                            }
                            
                        case .active:
                            Button("완료") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                viewStore.send(.tapEditButton(false))
                                
                            }
                        case .transient:
                            Button("unKnown") {
                                print("unknown")
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        WithViewStore(store) { viewStore in
                            Button {
                                viewStore.send(.tapSaveButton)
                            } label: {
                                Text("저장")
                            }
                        }
                    }
                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        if viewStore.editMode {
//                            if viewStore.isEditMode {
//                                Button("Apply") {
//                                    UIApplication.shared.sendAction(
//                                        #selector(UIResponder.resignFirstResponder),
//                                        to: nil,
//                                        from: nil,
//                                        for: nil
//                                    )
//                                    viewStore.send(.didEditTap)
//                                }
//                            } else {
//                                Button("Edit") {
//                                    viewStore.send(.didEditTap)
//                                }
//                            }
//                        } else {
//                            Button("Cancel") {
//                                viewStore.send(.didCancelTap)
//                            }
//                        }
//                    }
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Done") {
//                            viewStore.send(.didDoneTap)
//                        }
//                    }
//                }
            }
            .navigationViewStyle(.stack)
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
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
        ProjectDetailView(store: store)
            .previewLayout(.fixed(width: 1000, height: 1200))
            .padding()
    }
}
