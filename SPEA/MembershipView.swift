import SwiftUI
import Kingfisher
import UserNotifications

struct Membership: Identifiable, Codable {
    var id = UUID()
    var name: String
    var validity: String
    var details: String
    var logo: String

    enum CodingKeys: String, CodingKey {
        case name, validity, details, logo
    }
}

struct MembershipView: View {
    @ObservedObject private var viewModel = MembershipViewModel()
    @State private var settingsDetent = PresentationDetent.medium
    @State private var memberSelected: Membership? = nil
    @State private var showingSettings = false
    @State private var showExpireAlert = false
    @AppStorage("isMember") private var isMember: Bool = true
    @AppStorage("membershipExpiryDate") private var membershipExpiryDateString: String = ""
    @AppStorage("membershipTypeRaw") private var membershipTypeRaw: String = MembershipType.student.rawValue

    @State private var signUpDate = Date()

    private var membershipTypeBinding: Binding<MembershipType> {
        Binding(
            get: { MembershipType(rawValue: self.membershipTypeRaw) ?? .student },
            set: { self.membershipTypeRaw = $0.rawValue }
        )
    }

    var membershipExpiryDate: Date? {
        get {
            guard !membershipExpiryDateString.isEmpty else { return nil }
            return ISO8601DateFormatter().date(from: membershipExpiryDateString)
        }
        set {
            membershipExpiryDateString = newValue != nil ? ISO8601DateFormatter().string(from: newValue!) : ""
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if isMember, let expiryDate = membershipExpiryDate, membershipTypeBinding.wrappedValue != .lifetime, expiryDate >= Date() {
                        MembershipCardView(
                            member: Membership(
                                name: "\(membershipTypeBinding.wrappedValue.rawValue.capitalized) Membership",
                                validity: "Valid Until: \(formattedDate(expiryDate))",
                                details: "Access to benefits.    Type: \(membershipTypeBinding.wrappedValue.rawValue.capitalized)",
                                logo:"https://i.postimg.cc/RhNBVsck/SPEA.png"
                            )
                        )
                        .padding(.bottom, 20)
                    } else if isMember, membershipTypeBinding.wrappedValue == .lifetime {
                        MembershipCardView(
                            member: Membership(
                                name: "\(membershipTypeBinding.wrappedValue.rawValue.capitalized) Membership",
                                validity: "Lifetime Access",
                                details: "Access to benefits.    Type: \(membershipTypeBinding.wrappedValue.rawValue.capitalized)",
                                logo:"https://i.postimg.cc/RhNBVsck/SPEA.png"
                            )
                        )
                        .padding(.bottom, 20)
                    }

                    // Improved "Benefits" title
                    VStack(spacing: 10) {
                        Divider()
                            .background(Color.gray)
                        Text("Benefits")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                        Divider()
                            .background(Color.gray)
                    }
                    .padding(.vertical, 10)
                    
                    List(viewModel.memberList) { member in
                        Button {
                            memberSelected = member
                        } label: {
                            HStack {
                                KFImage(URL(string: member.logo))
                                    .resizable()
                                    .placeholder { LoadingView() }
                                    .onSuccess { result in print("Image loaded successfully: \(result.cacheType)") }
                                    .onFailure { error in print("Failed to load image: \(error.localizedDescription)") }
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .opacity(viewModel.isLoading ? 0 : 1)
                    
                    if viewModel.isLoading {
                        SmallAnimatedLoadingView()
                    }
                }
            }
            .navigationTitle("Membership")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                MembershipSettingsView(
                    signUpDate: $signUpDate,
                    membershipType: membershipTypeBinding,
                    isMember: $isMember,
                    membershipExpiryDateString: $membershipExpiryDateString
                )
            }
            .sheet(item: $memberSelected) { member in
                VStack(alignment: .leading) {
                    Spacer()
                    Text(member.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Divider()
                    Text(member.validity)
                        .padding()
                    Text(member.details)
                        .padding()
                    Spacer()
                }
                .presentationDetents([.medium, .large], selection: $settingsDetent)
            }
            .onAppear {
                checkMembershipStatus()
                scheduleExpiryWarningNotification() // Schedule the warning notification
            }
        }
    }

    private func checkMembershipStatus() {
        if isMember, let expiryDate = membershipExpiryDate, expiryDate < Date() {
            showRenewalPrompt()
        }
    }

    private func showRenewalPrompt() {
        let content = UNMutableNotificationContent()
        content.title = "Membership Expired"
        content.body = "Your membership has expired. Would you like to renew it?"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleExpiryWarningNotification() {
        guard isMember, let expiryDate = membershipExpiryDate, membershipTypeBinding.wrappedValue != .lifetime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Membership Expiring Soon"
        content.body = "Your membership is expiring soon. Please renew to continue enjoying benefits."
        content.sound = UNNotificationSound.default

        // Schedule the notification for 7 days before the expiry date
        if let warningDate = Calendar.current.date(byAdding: .day, value: -7, to: expiryDate) {
            let timeInterval = warningDate.timeIntervalSinceNow
            if timeInterval > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling warning notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func updateMembershipExpiryDate() {
        if membershipTypeBinding.wrappedValue != .lifetime {
            if let updatedExpiryDate = Calendar.current.date(byAdding: .year, value: 5, to: signUpDate) {
                membershipExpiryDateString = ISO8601DateFormatter().string(from: updatedExpiryDate)
            }
        } else {
            membershipExpiryDateString = ""
        }
    }
}

struct MembershipCardView: View {
    let member: Membership

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                KFImage(URL(string: member.logo))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()

                VStack(alignment: .leading) {
                    Text(member.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(member.validity)
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }

            Divider()
                .background(Color.white)

            Text(member.details)
                .foregroundColor(.white)
                .font(.body)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.red, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

#Preview {
    MembershipView()
}

#Preview {
    MembershipCardView(member: Membership(
        name: "Gold Membership",
        validity: "Valid Until: Aug 15, 2025",
        details: "Access to premium features and more benefits.",
        logo: "https://i.postimg.cc/RhNBVsck/SPEA.png"
    ))
    .previewLayout(.sizeThatFits)
    .padding()
}
