//
//  NewsletterViewModel.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 19/8/24.
//

import SwiftUI
import Combine

class NewsletterViewModel: ObservableObject {
    @Published var newsletters: [Newsletter] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let newsletterService = NewsletterService()

    func fetchNewsletters() {
        isLoading = true
        errorMessage = nil
        
        newsletterService.loadNewsletters { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newsletters):
                    self?.newsletters = newsletters.reversed() // Reverse to display the latest first
                case .failure(let error):
                    self?.errorMessage = "Failed to load newsletters: \(error.localizedDescription)"
                }
            }
        }
    }
}

class NewsletterDetailViewModel: ObservableObject {
    @Published var cachedTexts: [String: [String]] = [:]
    var sections: [NewsletterSection] = []


    func cacheText(for newsletter: Newsletter) {
        guard cachedTexts[newsletter.id] == nil else { return }
        
        var texts: [String] = []
        for sectionType in SectionType.allCases {
            if let newsletterSections = newsletter.sections {
                sections = newsletterSections.filter { $0.sectionType == sectionType.rawValue }
            }
            if !sections.isEmpty {
                texts.append(sectionType.title)
                for section in sections {
                    if !section.title.isEmpty { texts.append(section.title) }
                    if !section.content.isEmpty { texts.append(section.content) }
                    if let link = section.link, !link.isEmpty { texts.append("Read More: \(link)") }
                }
            }
        }
        cachedTexts[newsletter.id] = texts
    }
    
    func getText(for newsletter: Newsletter) -> [String] {
        cachedTexts[newsletter.id] ?? []
    }
}
