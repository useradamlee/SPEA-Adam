//
//  DataServiceA.swift
//  SPEA
//
//  Created by Javius Loh on 24/7/24.
//

import Foundation

class DataServiceA {
    let apiUrl = "https://script.google.com/macros/s/AKfycbwFjrOJA6NOStbmPVq1vdB1xcNbWTJ42uBBTEISX-h3DLJRamdhEATVnfm55CPlCg8z/exec"
    let jsonDecoder = JSONDecoder()
    
    func loadAnnouncements(completion: @escaping ([Announcement]) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion(loadCachedAnnouncements())
            return
        }
        
        // Load cached data if available before fetching from the network
        completion(loadCachedAnnouncements())
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(self.loadCachedAnnouncements()) // Fallback to cache if network fails
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(self.loadCachedAnnouncements())
                return
            }
            
            do {
                let announcements = try self.jsonDecoder.decode([Announcement].self, from: data)
                DispatchQueue.main.async {
                    self.cacheAnnouncements(announcements)
                    completion(announcements)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(self.loadCachedAnnouncements())
            }
        }.resume()
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
