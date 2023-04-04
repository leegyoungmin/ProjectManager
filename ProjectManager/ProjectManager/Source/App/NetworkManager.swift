//
//  NetworkManager.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
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
                let isConnected = (path.status == .satisfied)
                ProjectProvider.shared.setState(isConnect: isConnected)
                self?.isConnected = isConnected
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
