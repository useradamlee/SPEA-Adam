import Foundation

class EventDataService {
    private let apiUrl = "https://script.google.com/macros/s/AKfycbzU0bwOFEvgm2ZoTctAn_mMcrd-AHI6mxlzBcpIkuAejUaix_NhGJ5Bk5CUfj-qi9za/exec"
    private let jsonDecoder = JSONDecoder()
    private let cacheKey = "cachedEvents"
    
    // Public method to load events
    func loadEvents(completion: @escaping ([Event]) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion([]) // Fallback to empty list if URL is invalid
            return
        }
        
        // Load cached data if available
        if let cachedEvents = loadCachedEvents() {
            // Provide cached data immediately while fetching new data
            completion(cachedEvents)
        }
        
        // Fetch data from API
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(self.loadCachedEvents() ?? []) // Return cached data if available
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(self.loadCachedEvents() ?? []) // Return cached data if available
                return
            }
            
            do {
                let events = try self.jsonDecoder.decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.cacheEvents(events) // Cache the latest events data
                    completion(events) // Provide the latest data
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(self.loadCachedEvents() ?? []) // Return cached data if decoding fails
            }
        }.resume()
    }
    
    // Method to clear cache
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    // Private method to cache events
    private func cacheEvents(_ events: [Event]) {
        if let encodedEvents = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encodedEvents, forKey: cacheKey)
        }
    }
    
    // Private method to load cached events
    private func loadCachedEvents() -> [Event]? {
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let cachedEvents = try? jsonDecoder.decode([Event].self, from: cachedData) {
            return cachedEvents
        }
        return nil
    }
}
