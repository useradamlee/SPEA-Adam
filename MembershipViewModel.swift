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
