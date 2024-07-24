import Foundation

class DataService {
    func loadEvents(completion: @escaping ([Events]) -> Void) {
        guard let url = URL(string: "https://gsx2json.com/api?id=1OUhMffoZRSuP0sHqZrGplArwLvZRGowadJe1CclIYug&sheet=Event") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            let decoder = JSONDecoder()
            do {
                let eventData = try decoder.decode(EventsResponse.self, from: data)
                let events = eventData.rows
                DispatchQueue.main.async {
                    completion(events)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
