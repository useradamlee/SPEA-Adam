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
        Membership(name: "Chiropractic Health & Wellness Clinic", valid: "- Valid until 31 December 2024", details: "- One time $54.00 discount on their first consultation visit", logo: "ChiropracticHealth&Wellness")
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
