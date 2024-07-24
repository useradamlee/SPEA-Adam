import Foundation

class DataService {
    let apiUrl = "https://gsx2json.com/api?id=1OUhMffoZRSuP0sHqZrGplArwLvZRGowadJe1CclIYug&"
    let jsonDecoder = JSONDecoder()

    func loadEvents(completion: @escaping ([Events]) -> Void) {
        loadAnnouncements(from: "Event", completion: completion)
    }

    func loadAnnouncements(completion: @escaping ([Events]) -> Void) {
        loadAnnouncements(from: "Announcements", completion: completion)
    }

    private func loadAnnouncements(from sheet: String, completion: @escaping ([Events]) -> Void) {
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
                let eventdata = try self.jsonDecoder.decode(EventsResponse.self, from: data)
                let Event = eventdata.rows
                print("Successfully fetched and decoded data: \(Event)") // Debug print
                DispatchQueue.main.async {
                    completion(Event)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}

// Model for the top-level JSON structure
struct EventsResponse: Codable {
    let rows: [Events]
}
