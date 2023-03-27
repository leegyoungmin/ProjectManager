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
        NavigationView {
            VStack(spacing: 30) {
                UserInformationSection(title: "이메일") {
                    emailSection
                }
                
                UserInformationSection(title: "비밀번호") {
                    passwordSection
                }
                
                UserInformationSection(title: "비밀번호 확인") {
                    confirmPasswordSection
                }
                
                Spacer()
            }
            .padding(30)
            .navigationTitle("회원 가입")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

extension SignUpView {
    struct UserInformationSection<Content: View>: View {
        let title: String
        @ViewBuilder var content: () -> Content
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 30).bold())
                
                content()
            }
        }
    }
    
    var emailSection: some View {
        WithViewStore(store) { viewStore in
            TextField("", text: viewStore.binding(\.$email))
                .placeholder(when: viewStore.email.isEmpty) {
                    Text("이메일을 입력해주세요.")
                        .foregroundColor(.gray)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: .infinity)
                        .strokeBorder(Color.accentColor)
                }
        }
    }
    
    var passwordSection: some View {
        WithViewStore(store) { viewStore in
            SecureField("", text: viewStore.binding(\.$password))
                .placeholder(when: viewStore.password.isEmpty) {
                    Text("비밀번호를 입력해주세요.")
                        .foregroundColor(.gray)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: .infinity)
                        .strokeBorder(Color.accentColor)
                }
        }
    }
    
    var confirmPasswordSection: some View {
        WithViewStore(store) { viewStore in
            VStack {
                SecureField("", text: viewStore.binding(\.$confirmPassword))
                    .placeholder(when: viewStore.confirmPassword.isEmpty) {
                        Text("비밀번호를 다시한번 입력해주세요.")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .strokeBorder(Color.accentColor)
                    }
                
                // TODO: - 비밀번호 Validation Text 생성
                Text(viewStore.isCorrect.description)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static let store = Store(
        initialState: SignUpCore.State(),
        reducer: SignUpCore()
    )
    static var previews: some View {
        SignUpView(store: store)
            .previewLayout(.fixed(width: 600, height: 800))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
