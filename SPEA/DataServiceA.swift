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
            completion([])
            return
        }
        
        // Load cached data if available
        if let cachedAnnouncementsData = UserDefaults.standard.data(forKey: "cachedAnnouncements"),
           let cachedAnnouncements = try? jsonDecoder.decode([Announcement].self, from: cachedAnnouncementsData) {
            completion(cachedAnnouncements)
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion([])
                return
            }
            
            do {
                let announcements = try self.jsonDecoder.decode([Announcement].self, from: data)
                DispatchQueue.main.async {
                    // Cache the announcements data
                    if let encodedAnnouncements = try? JSONEncoder().encode(announcements) {
                        UserDefaults.standard.set(encodedAnnouncements, forKey: "cachedAnnouncements")
                    }
                    completion(announcements)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}
