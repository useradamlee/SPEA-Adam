//
//  AnnouncementViewModel.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 8/8/24.
//

import Foundation

class AnnouncementViewModel: ObservableObject {
    @Published var announcementList: [Announcement] = []
    @Published var isLoading = true
    private var dataService: DataServiceA
    
    init(dataService: DataServiceA = DataServiceA()) {
        self.dataService = dataService
        loadAnnouncements()
    }
    
    func loadAnnouncements() {
        dataService.loadAnnouncements { [weak self] loadedAnnouncements in
            self?.announcementList = loadedAnnouncements
            self?.isLoading = false  // Hide the loading view once data is loaded
            print("Updated announcement list: \(self?.announcementList ?? [])") // Debug print
        }
    }
}
