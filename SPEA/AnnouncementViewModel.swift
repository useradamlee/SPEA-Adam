//
//  AnnouncementViewModel.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 8/8/24.
//

import Foundation
import Combine

class AnnouncementViewModel: ObservableObject {
    @Published var announcementList: [Announcement] = []
    @Published var isLoading = true
    private var dataService: DataServiceA
    private var cancellables = Set<AnyCancellable>() // To handle Combine subscriptions
    
    init(dataService: DataServiceA = DataServiceA()) {
        self.dataService = dataService
        setupBindings()
        dataService.loadAnnouncements()
    }
    
    private func setupBindings() {
        // Subscribe to changes in the dataService's announcements
        dataService.$announcements
            .receive(on: DispatchQueue.main)
            .sink { [weak self] announcements in
                self?.announcementList = announcements.reversed() // Reverse to show latest first
                self?.isLoading = announcements.isEmpty // Update loading state based on data availability
            }
            .store(in: &cancellables)
    }
    
    func clearCache() {
        dataService.clearCache() // Clear cache and update view accordingly
    }
}
