//
//  MembershipSettingsView.swift
//  SPEA
//
//  Created by Lee Jun Lei Adam on 16/8/24.
//

import SwiftUI

struct MembershipSettingsView: View {
    @Binding var signUpDate: Date
    @Binding var membershipType: MembershipType
    @Binding var isMember: Bool
    @Binding var membershipExpiryDateString: String
    @State private var isSavePressed = false
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(header: Text("Membership Information")) {
                DatePicker("Sign-Up Date", selection: $signUpDate, displayedComponents: .date)
                    .padding()

                Picker("Membership Type", selection: $membershipType) {
                    ForEach(MembershipType.allCases) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .padding()

                if membershipType != .lifetime {
                    Text("Membership Duration: 5 years")
                        .padding()
                } else {
                    Text("Lifetime Membership")
                        .padding()
                }
            }

            Button(action: {
                completeSignUp()
                self.isSavePressed.toggle()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Complete")
                }
            }
            .scaleEffect(isSavePressed ? 1.1 : 1.0)
            .animation(.easeInOut, value: isSavePressed)
            .padding()
            .fontWeight(.bold)
            .foregroundColor(.red)
            .accessibility(label: Text("Complete Sign-Up"))

            Section(footer: importantInformationView()) {}

            if hasInformationToDelete {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Membership")
                    }
                }
                .foregroundColor(.red)
                .padding()
                .alert("Are you sure you want to delete this membership?", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        deleteMembership()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
            }
        }
        .navigationTitle("Edit Membership")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    completeSignUp()
                }
            }
        }
    }

    @ViewBuilder
    private func importantInformationView() -> some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.yellow)

            VStack(alignment: .leading) {
                Text("This is just to keep track of the deadline of the membership and not for official purposes.")

                Link("To sign up, go here", destination: URL(string: "https://bit.ly/SPEA_Membership_Application_Form")!)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
            }
            .font(.footnote)
            .padding(.leading, 5)
        }
        .padding(.top)
    }

    private func completeSignUp() {
        // Set isMember to true
        isMember = true

        // Calculate and save expiry date for non-lifetime memberships
        if membershipType != .lifetime {
            if let expiryDate = Calendar.current.date(byAdding: .year, value: 5, to: signUpDate) {
                membershipExpiryDateString = ISO8601DateFormatter().string(from: expiryDate)
            }
        } else {
            // For lifetime membership, clear the expiry date
            membershipExpiryDateString = ""
        }

        // Save membership type
        UserDefaults.standard.set(membershipType.rawValue, forKey: "membershipTypeRaw")

        // Dismiss the view
        dismiss()
    }

    private func deleteMembership() {
        // Reset the membership information
        isMember = false
        signUpDate = Date()
        membershipType = .student // Reset to a default type if needed
        membershipExpiryDateString = ""

        // Optionally clear saved data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "membershipTypeRaw")

        // Dismiss the view after deletion
        dismiss()
    }

    private var hasInformationToDelete: Bool {
        // Determine if there is membership information to delete
        return isMember || !membershipExpiryDateString.isEmpty || membershipType != .student
    }
}

enum MembershipType: String, CaseIterable, Identifiable {
    case student = "Student"
    case ordinary = "Ordinary"
    case lifetime = "Lifetime"

    var id: String { rawValue }
}

#Preview {
    MembershipSettingsView(
        signUpDate: .constant(Date()),
        membershipType: .constant(.student),
        isMember: .constant(false),
        membershipExpiryDateString: .constant("")
    )
}
