//
//  DataServiceA.swift
//  SPEA
//
//  Created by Javius Loh on 24/7/24.
//

import Foundation

class DataServiceA: ObservableObject {
    let apiUrl = "https://script.google.com/macros/s/AKfycbwFjrOJA6NOStbmPVq1vdB1xcNbWTJ42uBBTEISX-h3DLJRamdhEATVnfm55CPlCg8z/exec"
    let jsonDecoder = JSONDecoder()
    
    @Published var announcements: [Announcement] = [] // This is now a published property

    func loadAnnouncements() {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            self.announcements = loadCachedAnnouncements()
            return
        }
        
        // Load cached data first
        self.announcements = loadCachedAnnouncements()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self.announcements = self.loadCachedAnnouncements() // Fallback to cache if network fails
                }
                return
            }
            
            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async {
                    self.announcements = self.loadCachedAnnouncements()
                }
                return
            }
            
            do {
                let fetchedAnnouncements = try self.jsonDecoder.decode([Announcement].self, from: data)
                DispatchQueue.main.async {
                    self.cacheAnnouncements(fetchedAnnouncements)
                    self.announcements = fetchedAnnouncements
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.announcements = self.loadCachedAnnouncements()
                }
            }
        }.resume()
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: "cachedAnnouncements")
        self.announcements = [] // Clear the announcements in memory
    }
    
    private func cacheAnnouncements(_ announcements: [Announcement]) {
        if let encodedAnnouncements = try? JSONEncoder().encode(announcements) {
            UserDefaults.standard.set(encodedAnnouncements, forKey: "cachedAnnouncements")
        }
    }
    
    private func loadCachedAnnouncements() -> [Announcement] {
        if let cachedData = UserDefaults.standard.data(forKey: "cachedAnnouncements"),
           let cachedAnnouncements = try? jsonDecoder.decode([Announcement].self, from: cachedData) {
            return cachedAnnouncements
        }
        return []
    }
}
