//
//  MembershipView.swift
//  SPEA
//
//  Created by Javius Loh on 30/5/24.
//

import SwiftUI

struct Membership: Identifiable {
    var id = UUID()
    var name: String
    var valid: String
    var details: String
    var logo: String
}

struct MembershipView: View {
        
    @State var memberList = [
        Membership(name: "Beary Fun Gym", valid: "- Valid until 31 July 2024", details: "- 20% off One (1) Term Gymnastics Programme Fee at any one of the outlets: \nBukit Batok / Changi / Choa Chu Kang / Katong", logo: "BearyFunGym"),
        Membership(name: "Chiropractic Health & Wellness Clinic", valid: "- Valid until 31 December 2024", details: "- One time $54.00 discount on their first consultation visit", logo: "ChiropracticHealth&Wellness"),
        Membership(name: "Guang An TCM", valid: "- Valid until 31 July 2024", details: "- 15% off Sport Recovery Tuina \n- 10% off all other body / foot massage \n\n* Booking in advance is required, subject to availability", logo: "GuangAnTCM"),
        Membership(name: "Singapore Raffles Music College", valid: "- Valid until 28 July 2024", details: "- SRMC will offer one (1) place for full sponsorship of the programme fees of up to $20,500 in each calendar year and two (2) places for partial sponsorship of the programme fees of up to $10,000 for each place in each calendar year to SPEA Members and their immediate family members who are enrolled as new students of SRMC. \n\n- Applicable to the following Programmes only;\no   Certificate in Music\no   Diploma in Music\no   Advanced Diploma in Music\no   Advanced Diploma in Dance \n\n- Eligibility criteria applies.", logo: "SingaporeRafflesMusicCollege"),
    ]
    @State private var settingsDetent = PresentationDetent.medium
    @State private var showingMembership = false
    
    @State private var memberSelected: Membership? = nil

    var body: some View {
        NavigationStack{
            List {
                ForEach(memberList, id: \.id) { member in
                    Button{
                        memberSelected = member
                    } label:{
                        HStack{
                            VStack(alignment: .leading){
                                Image(member.logo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Membership")
            .sheet(item: $memberSelected) { member in
                VStack(alignment: .leading){
                    Spacer()
                    Text(member.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Divider()
                    Text(member.valid)
                        .padding()
                    Text(member.details)
                        .padding()
                    Spacer()
                }
                .presentationDetents(
                    [.medium, .large],
                    selection: $settingsDetent
                )
            }
        }
    }
}

#Preview {
    MembershipView()
}
