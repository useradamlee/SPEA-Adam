import Foundation

class MembershipService {
    let apiUrl = "https://script.google.com/macros/s/AKfycbwQl8MEJeRJIt4LGclG2-z7Fz3vJpeZCz2MQqqLOuXldRY4hEfVxbPHAb7mDsf0rI-n/exec"
    let jsonDecoder = JSONDecoder()
    
    func loadMemberships(completion: @escaping ([Membership]) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        // Load cached data if available
        if let cachedMembershipsData = UserDefaults.standard.data(forKey: "cachedMemberships"),
           let cachedMemberships = try? jsonDecoder.decode([Membership].self, from: cachedMembershipsData) {
            completion(cachedMemberships)
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
                let memberships = try self.jsonDecoder.decode([Membership].self, from: data)
                DispatchQueue.main.async {
                    // Cache the memberships data
                    if let encodedMemberships = try? JSONEncoder().encode(memberships) {
                        UserDefaults.standard.set(encodedMemberships, forKey: "cachedMemberships")
                    }
                    completion(memberships)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}
