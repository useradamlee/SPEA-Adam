//
//  FirstTimeLaunchView.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 16/8/24.
//

import SwiftUI

struct FirstTimeLaunchView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isMember") private var isMember: Bool = false
    @AppStorage("membershipExpiryDate") private var membershipExpiryDateString: String = ""
    @AppStorage("membershipTypeRaw") private var membershipTypeRaw: String = MembershipType.student.rawValue

    @State private var signUpDate: Date = Date()
    @State private var showMemberSignUp: Bool = false

    private var membershipTypeBinding: Binding<MembershipType> {
        Binding(
            get: { MembershipType(rawValue: self.membershipTypeRaw) ?? .student },
            set: { self.membershipTypeRaw = $0.rawValue }
        )
    }

    var body: some View {
        VStack(spacing: 30) {
            Image("SPEA") // Assuming "SPEA" is the name of your image asset
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 200)

            Text("Welcome to SPEA")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(.bottom, 10)

            Text("Are you a member?")
                .font(.title2)
                .foregroundColor(.primary)

            VStack(spacing: 15) {
                Button(action: {
                    showMemberSignUp = true
                }) {
                    Text("Yes")
                        .frame(maxWidth: .infinity)
                }
                .accessibility(label: Text("Yes"))
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .font(.system(size: 20, weight: .bold))

                Button(action: {
                    isMember = false
                    isFirstLaunch = false
                }) {
                    Text("No, I just want updates")
                        .frame(maxWidth: .infinity)
                }
                .accessibility(label: Text("No, I just want updates"))
                .buttonStyle(.bordered)
                .controlSize(.large)
                .font(.system(size: 20))
            }
            .padding(.horizontal, 40)
        }
        .sheet(isPresented: $showMemberSignUp) {
            MembershipSettingsView(
                signUpDate: $signUpDate,
                membershipType: membershipTypeBinding,
                isMember: $isMember,
                membershipExpiryDateString: $membershipExpiryDateString
            )
            .onDisappear {
                if isMember {
                    isFirstLaunch = false
                }
            }
        }
        .accentColor(.red)
        .padding()
    }
}

#Preview {
    FirstTimeLaunchView()
}
