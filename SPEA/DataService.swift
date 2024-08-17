import Foundation

class EventDataService {
    let apiUrl = "https://script.google.com/macros/s/AKfycbzU0bwOFEvgm2ZoTctAn_mMcrd-AHI6mxlzBcpIkuAejUaix_NhGJ5Bk5CUfj-qi9za/exec"
    let jsonDecoder = JSONDecoder()
    
    func loadEvents(completion: @escaping ([Event]) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion([]) // Fallback to empty list if URL is invalid
            return
        }
        
        // Load cached data if available
        if let cachedEventsData = UserDefaults.standard.data(forKey: "cachedEvents"),
           let cachedEvents = try? jsonDecoder.decode([Event].self, from: cachedEventsData) {
            // Provide cached data immediately while fetching new data
            completion(cachedEvents)
        }
        
        // Fetch data from API
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion([]) // Return empty list if there's an error
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion([]) // Return empty list if no data is returned
                return
            }
            
            do {
                let events = try self.jsonDecoder.decode([Event].self, from: data)
                DispatchQueue.main.async {
                    // Cache the events data for offline access
                    if let encodedEvents = try? JSONEncoder().encode(events) {
                        UserDefaults.standard.set(encodedEvents, forKey: "cachedEvents")
                    }
                    completion(events) // Provide the latest data
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([]) // Return empty list if decoding fails
            }
        }.resume()
    }
}
