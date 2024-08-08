//
//  EventViewModel.swift
//  SPEA-test
//
//  Created by Lee Jun Lei Adam on 8/8/24.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var eventList: [Event] = []
    @Published var isLoading = true
    private var dataService: EventDataService
    
    init(eventDataService: EventDataService = EventDataService()) {
        self.dataService = eventDataService
        loadEvents()
    }
    
    func loadEvents() {
        dataService.loadEvents { [weak self] loadedEvents in
            self?.eventList = loadedEvents
            self?.isLoading = false  // Hide the loading view once data is loaded
            print("Updated event list: \(self?.eventList ?? [])") // Debug print
        }
    }
}
