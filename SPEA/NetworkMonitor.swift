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
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
