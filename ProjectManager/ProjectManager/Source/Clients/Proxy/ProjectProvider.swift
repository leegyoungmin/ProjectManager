//
//  ProjectProvider.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Firebase

protocol ProjectLoadService {
    func loadProjects(with state: ProjectState) async -> [Project]
    func deleteProject(with project: Project) async -> Bool
    func saveProject(with project: Project) async -> Bool
}

final class ProjectProvider: ProjectLoadService {
    static let shared = ProjectProvider()
    
    private var coreDataManager: ProjectLoadService?
    @Published private var isConnected: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        $isConnected.sink {
            if $0 {
                self.coreDataManager = nil
            } else {
                self.coreDataManager = CoreDataManager.shared
            }
        }
        .store(in: &cancellables)
    }
    
    func setState(isConnect: Bool) {
        self.isConnected = isConnect
    }
    
    func loadProjects(with state: ProjectState) async -> [Project] {
        if let coreDataManager = coreDataManager {
            return await coreDataManager.loadProjects(with: state)
        } else {
            guard let projects = try? await loadFirebase(with: state) else {
                return []
            }
            
            return projects
        }
    }
    
    func deleteProject(with project: Project) async -> Bool {
        if let coreDataManager = coreDataManager {
            _ = await coreDataManager.deleteProject(with: project)
        }
        
        guard let result = try? await deleteDatabase(with: project) else {
            return false
        }
        
        return result
    }
    
    func saveProject(with project: Project) async -> Bool {
        if let coreDataManager = coreDataManager {
            _ = await coreDataManager.saveProject(with: project)
        }
        
        guard let result = try? await saveDatabase(with: project) else {
            return false
        }
        
        return result
    }
}

extension ProjectProvider {
    enum URLError: Error {
        case invalidUser
        case fetchUserInformation
        case unknown
    }
}
