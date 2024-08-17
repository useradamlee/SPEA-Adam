//
//  MembershipViewModel.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 8/8/24.
//

import Foundation

class MembershipViewModel: ObservableObject {
    
    @Published var memberList: [Membership] = []
    @Published var isLoading = true
    
    // Add the missing properties
    @Published var membershipName: String = ""
    @Published var membershipValidity: String = ""
    @Published var membershipDetails: String = ""
    @Published var membershipLogo: String = ""
    
    private var membershipService: MembershipService
    
    init(membershipService: MembershipService = MembershipService()) {
        self.membershipService = membershipService
        loadMemberships()
    }
    
    func loadMemberships() {
        membershipService.loadMemberships { [weak self] loadedMemberships in
            self?.memberList = loadedMemberships
            self?.isLoading = false  // Hide the loading view once data is loaded
            print("Updated member list: \(self?.memberList ?? [])") // Debug print
        }
    }
}

