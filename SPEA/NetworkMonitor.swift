//
//  NetworkMonitor.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 17/8/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    private var monitor = NWPathMonitor()
    private var queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true
    @Published var connectionStatusMessage: String = "Connected" // New property to track status message
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isConnected = true
                    self.connectionStatusMessage = "Connected" // Update message when connected
                } else {
                    self.isConnected = false
                    self.connectionStatusMessage = "Disconnected" // Update message when disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
