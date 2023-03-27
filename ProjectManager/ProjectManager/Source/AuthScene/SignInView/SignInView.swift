//
//  AuthView.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct SignInView: View {
    let store: StoreOf<SignInCore>
    
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
        .background(LinearGradient(colors: [Color("DarkAccent"), Color.accentColor], startPoint: .top, endPoint: .bottom))
    }
}

private extension SignInView {
    var titleSection: some View {
        Text("Sorting")
            .foregroundColor(.white)
            .font(.system(size: 100, weight: .bold))
            .frame(maxHeight: 300, alignment: .bottom)
            .padding()
    }
    
    var emailSection: some View {
        WithViewStore(store) { viewStore in
            TextField("", text: viewStore.binding(\.$email))
                .placeholder("Email", when: viewStore.email.isEmpty)
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
    }
    
    var passwordSection: some View {
        WithViewStore(store) { viewStore in
            SecureField("", text: viewStore.binding(\.$password))
                .placeholder("password", when: viewStore.password.isEmpty)
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
    }
    
    var loginButton: some View {
        Button {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
            ViewStore(store).send(.login)
        } label: {
            Text("로그인하기")
        }
        .frame(maxWidth: 400)
        .foregroundColor(.white)
        .padding()
        .cornerRadius(.infinity)
        .background {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Color.accentColor)
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
    static let previewDevices = [
        "iPad (9th generation)",
        "iPad Air",
        "iPad mini (5th generation)",
        "iPad Pro (9.7-inch)",
        "iPad Pro (12.9-inch) (6th generation)"
    ]
    static let store = Store(initialState: SignInCore.State(), reducer: SignInCore())
    static var previews: some View {
        Group {
            ForEach(previewDevices, id: \.self) {
                SignInView(store: store)
                    .previewInterfaceOrientation(.landscapeRight)
                    .previewDevice(PreviewDevice(rawValue: $0))
                    .previewLayout(.sizeThatFits)
                    .previewDisplayName($0)
            }
        }
        
    }
}
