//
//  ProjectProvider.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Network

protocol ProjectLoadService {
    func loadProjects(with state: ProjectState) -> [Project]
    func deleteProject(with project: Project) -> Bool
    func saveProject(with project: Project) -> Bool
}

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    @Published private(set) var isConnected: Bool = false
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

class ProjectProvider: ProjectLoadService {
    private var isConnected: Bool = false
    private var cancellables = Set<AnyCancellable>()
    static let shared = ProjectProvider()
    let coreDataManager = CoreDataManager.shared
    let networkManager = NetworkMonitor.shared
    
    init() {
        networkManager.$isConnected
            .sink { [weak self] in self?.isConnected = $0 }
            .store(in: &cancellables)
    }
    
    func loadProjects(with state: ProjectState) -> [Project] {
        return []
    }
    
    func deleteProject(with project: Project) -> Bool {
        return true
    }
    
    func saveProject(with project: Project) -> Bool {
        return true
    }
}
