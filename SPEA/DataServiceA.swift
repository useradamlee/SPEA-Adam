//
//  DataServiceA.swift
//  SPEA
//
//  Created by Javius Loh on 24/7/24.
//

import Foundation

class DataServiceA {
    let apiUrl = "https://gsx2json.com/api?id=1OUhMffoZRSuP0sHqZrGplArwLvZRGowadJe1CclIYug&"
    let jsonDecoder = JSONDecoder()

    func loadEvents(completion: @escaping ([Announcement]) -> Void) {
        loadAnnouncements(from: "Event", completion: completion)
    }

    func loadAnnouncements(completion: @escaping ([Announcement]) -> Void) {
        loadAnnouncements(from: "Announcements", completion: completion)
    }

    private func loadAnnouncements(from sheet: String, completion: @escaping ([Announcement]) -> Void) {
        guard let url = URL(string: apiUrl + "sheet=" + sheet) else {
            print("Invalid URL")
            completion([])
            return
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
                let announcementData = try self.jsonDecoder.decode(AnnouncementsResponse.self, from: data)
                let announcements = announcementData.rows
                print("Successfully fetched and decoded data: \(announcements)") // Debug print
                DispatchQueue.main.async {
                    completion(announcements)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}

// Model for the top-level JSON structure, essentially the same as events
struct AnnouncementsResponse: Codable {
    let rows: [Announcement]
}
