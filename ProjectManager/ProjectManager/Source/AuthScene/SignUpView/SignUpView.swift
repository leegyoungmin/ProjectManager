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
            ScrollView {
                ZStack {
                    WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                        VStack(spacing: 30) {
                            Spacer()
                            
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
                            
                            signUpButton
                            
                            Spacer()
                        }
                        .disabled(viewStore.state)
                        
                        
                        if viewStore.state {
                            ProgressView()
                        }
                    }
                }
                .padding(30)
                .navigationTitle("회원 가입")
                .navigationBarTitleDisplayMode(.inline)
            }
            
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
                    .font(.system(size: 40).bold())
                
                content()
            }
        }
    }
    
    var emailSection: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                TextField("", text: viewStore.binding(\.$email))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .placeholder(when: viewStore.email.isEmpty) {
                        Text(Constants.emailFieldPlaceholder)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .strokeBorder(Color.accentColor)
                    }
                
                // TODO: - Valid Text 생성
                Text(viewStore.isValidEmail ? "" : Constants.inValidEmailDescription)
                    .opacity(viewStore.email.isEmpty ? 0 : 1)
                    .opacity(viewStore.isValidEmail ? 0 : 1)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    var passwordSection: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                SecureField("", text: viewStore.binding(\.$password))
                    .placeholder(when: viewStore.password.isEmpty) {
                        Text(Constants.passwordFieldPlaceholder)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .strokeBorder(Color.accentColor)
                    }
                
                // TODO: - Valid Password Text
                Text(viewStore.isValidPassword ? "" : Constants.inValidPasswordDescription)
                    .opacity(viewStore.password.isEmpty ? 0 : 1)
                    .opacity(viewStore.isValidPassword ? 0 : 1)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    var confirmPasswordSection: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                SecureField("", text: viewStore.binding(\.$confirmPassword))
                    .placeholder(when: viewStore.confirmPassword.isEmpty) {
                        Text(Constants.passwordConfirmFieldPlaceholder)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .strokeBorder(Color.accentColor)
                    }
                
                // TODO: - 비밀번호 Validation Text 생성
                Text(viewStore.isCorrect ? "" : Constants.inValidPasswordConfirmDescription)
                    .opacity(viewStore.confirmPassword.isEmpty ? 0 : 1)
                    .opacity(viewStore.isCorrect ? 0 : 1)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    var signUpButton: some View {
        Button("회원가입하기") {
            ViewStore(store).send(.signUp)
        }
        .foregroundColor(.white)
        .font(.title.bold())
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Color.accentColor)
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

private extension SignUpView {
    enum Constants {
        
        static let emailFieldPlaceholder: String = "이메일을 입력해주세요."
        static let passwordFieldPlaceholder: String = "비밀번호를 입력해주세요."
        static let passwordConfirmFieldPlaceholder: String = "비밀번호를 다시한번 입력해주세요."
        
        static let inValidEmailDescription: String = "이메일 형식에 맞지 않습니다. 다시한번 확인해주세요."
        static let inValidPasswordDescription: String = "올바르지 않은 비밀번호 형식입니다.\n영어, 특수문자, 숫자를 포함하여 20자 이하여야 합니다."
        static let inValidPasswordConfirmDescription: String = "비밀번호가 동일하지 않습니다. 확인해주세요."
    }
}
