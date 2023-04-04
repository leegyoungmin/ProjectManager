//
//  ProjectProvider + FireStore.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Firebase
import FirebaseFirestoreSwift

extension ProjectProvider {
    func loadFirebase(with state: ProjectState) async throws -> [Project] {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError.invalidUser
        }
        
        let store = Firestore.firestore()
        let authDocument = store.collection("Users").document(currentUser.uid)
        
        guard let projectIDs = try? await authDocument.getDocument(as: UserInformation.self).projectIds,
              projectIDs.isEmpty == false else {
            throw URLError.fetchUserInformation
        }
        
        let querySansphot = try await store
            .collection("Projects")
            .whereField("id", in: projectIDs)
            .whereField("state", isEqualTo: state.rawValue)
            .getDocuments()
        
        var projects = [Project]()
        
        for document in querySansphot.documents {
            let project = try document.data(as: Project.self)
            projects.append(project)
        }
        return projects
    }
    
    func deleteDatabase(with project: Project) async throws -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError.invalidUser
        }
        
        let store = Firestore.firestore()
        let authDocument = store.collection("Users").document(currentUser.uid)
        let document = store.collection("Projects").document(project.id.uuidString)
        
        guard let _ = try? await document.delete(),
              let _ = try? await authDocument.updateData([
                  "projectIds": FieldValue.arrayRemove([project.id.uuidString])
              ]) else {
            throw URLError.unknown
        }
        
        return true
    }
    
    func saveDatabase(with project: Project) async throws -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError.invalidUser
        }
        
        let store = Firestore.firestore()
        let authDocument = store.collection("Users").document(currentUser.uid)
        let document = store.collection("Projects").document(project.id.uuidString)
        
        guard let _ = try? document.setData(from: project) else {
            throw URLError.unknown
        }
        
        try await authDocument.updateData([
            "projectIds": FieldValue.arrayUnion([project.id.uuidString])
        ])
        
        return true
    }
}
