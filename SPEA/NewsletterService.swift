//
//  NewsletterService.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 19/8/24.
//

import Foundation

struct NewsletterResponse: Codable {
    let newsletters: [Newsletter]
}

// MARK: - Services

class NewsletterService {
    private let apiUrl = "https://script.google.com/macros/s/AKfycbx8CoHXCBrO8TwOTUHpTzO3Gec5wOznaqRuuexABqUOalZRGP28UfLdUu4LEmQZLeQ/exec"
    private let jsonDecoder = JSONDecoder()
    
    func loadNewsletters(useCache: Bool = true, completion: @escaping (Result<[Newsletter], Error>) -> Void) {
        if useCache {
            let cachedNewsletters = loadCachedNewsletters()
            if !cachedNewsletters.isEmpty {
                completion(.success(cachedNewsletters))
            }
        }

        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let response = try self.jsonDecoder.decode(NewsletterResponse.self, from: data)
                self.cacheNewsletters(response.newsletters)
                completion(.success(response.newsletters))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func cacheNewsletters(_ newsletters: [Newsletter]) {
        DispatchQueue.global(qos: .background).async {
            if let encodedNewsletters = try? JSONEncoder().encode(NewsletterResponse(newsletters: newsletters)) {
                UserDefaults.standard.set(encodedNewsletters, forKey: "cachedNewsletters")
            }
        }
    }
    
    private func loadCachedNewsletters() -> [Newsletter] {
        guard let cachedData = UserDefaults.standard.data(forKey: "cachedNewsletters"),
              let response = try? jsonDecoder.decode(NewsletterResponse.self, from: cachedData) else {
            return []
        }
        return response.newsletters
    }
}
