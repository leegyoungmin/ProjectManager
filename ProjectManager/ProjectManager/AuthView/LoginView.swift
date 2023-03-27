//
//  AuthView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center) {
                
                titleSection
                
                emailSection
                
                passwordSection
                
                loginButton
                
                signUpSection
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

private extension LoginView {
    var titleSection: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 200)
            
            Text("Sorting")
                .foregroundColor(.white)
                .font(.system(size: 100, weight: .bold))
        }
    }
    
    var emailSection: some View {
        TextField("", text: $email)
            .placeholder("Email", when: email.isEmpty)
            .foregroundColor(.white)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(maxWidth: 400)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: .infinity)
                    .strokeBorder()
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
    }
    
    var passwordSection: some View {
        SecureField("", text: $password)
            .placeholder("password", when: email.isEmpty)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(maxWidth: 400)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: .infinity)
                    .strokeBorder()
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
    }
    
    var loginButton: some View {
        Button {
            print("Tapped Login Button")
        } label: {
            Text("로그인하기")
        }
        .frame(maxWidth: 400)
        .foregroundColor(.white)
        .padding()
        .cornerRadius(.infinity)
        .background {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Color(red: 60 / 255, green: 120 / 255, blue: 170 / 255))
        }
        .padding()
    }
    
    var signUpSection: some View {
        HStack {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(.white.opacity(0.5))
                .frame(maxWidth: 150, maxHeight: 3)
            
            HStack {
                Text("아직 회원이 아니신가요?")
                    .foregroundColor(.white)
                
                Button {
                    print("Tapped Sign up")
                } label: {
                    Text("회원 가입하기")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: .infinity)
                .fill(.white.opacity(0.5))
                .frame(maxWidth: 150, maxHeight: 3)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .background(Gradient(colors: [Color(red: 29 / 255, green: 39 / 255, blue: 60 / 255), Color(red: 60 / 255, green: 120 / 255, blue: 170 / 255)]))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
