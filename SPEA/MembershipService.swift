import Foundation

class MembershipService {
    let apiUrl = "https://script.google.com/macros/s/AKfycbwQl8MEJeRJIt4LGclG2-z7Fz3vJpeZCz2MQqqLOuXldRY4hEfVxbPHAb7mDsf0rI-n/exec"
    let jsonDecoder = JSONDecoder()
    let cacheKey = "CachedMemberships"

    func loadMemberships(completion: @escaping ([Membership]) -> Void) {
        guard let url = URL(string: apiUrl) else {
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
                let membershipData = try self.jsonDecoder.decode([Membership].self, from: data)
                // Save to cache
                self.saveToCache(data)
                DispatchQueue.main.async {
                    completion(membershipData)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    // Load from cache if decoding fails
                    if let cachedData = self.loadFromCache() {
                        completion(cachedData)
                    } else {
                        completion([])
                    }
                }
            }
        }.resume()
    }

    private func saveToCache(_ data: Data) {
        UserDefaults.standard.set(data, forKey: cacheKey)
    }

    private func loadFromCache() -> [Membership]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? jsonDecoder.decode([Membership].self, from: data)
    }
}
