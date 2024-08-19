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

    private var membershipType: MembershipType {
        get { MembershipType(rawValue: membershipTypeRaw) ?? .student }
        set { membershipTypeRaw = newValue.rawValue }
    }

    private var membershipExpiryDate: Date? {
        get {
            guard !membershipExpiryDateString.isEmpty else { return nil }
            return ISO8601DateFormatter().date(from: membershipExpiryDateString)
        }
        set {
            membershipExpiryDateString = newValue.map { ISO8601DateFormatter().string(from: $0) } ?? ""
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if isMember, let expiryDate = membershipExpiryDate, membershipType != .lifetime, expiryDate >= Date() {
                        membershipCard(validity: "Valid Until: \(formattedDate(expiryDate))")
                    } else if isMember, membershipType == .lifetime {
                        membershipCard(validity: "Lifetime Access")
                    }

                    // Improved "Benefits" title
                    benefitsTitle()

                    List(viewModel.memberList) { member in
                        Button {
                            memberSelected = member
                        } label: {
                            memberLogoView(logoURL: member.logo)
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
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape") }
                    .accessibility(label: Text("Membership Settings"))
                }
            }
            .sheet(isPresented: $showingSettings) {
                MembershipSettingsView(
                    signUpDate: $signUpDate,
                    membershipType: Binding(
                        get: { MembershipType(rawValue: membershipTypeRaw) ?? .student },
                        set: { membershipTypeRaw = $0.rawValue }
                    ),
                    isMember: $isMember,
                    membershipExpiryDateString: $membershipExpiryDateString
                )
            }
            .sheet(item: $memberSelected) { member in
                memberDetailsSheet(member: member)
            }
            .onAppear {
                checkMembershipStatus()
                scheduleExpiryWarningNotification()
            }
        }
    }

    private func membershipCard(validity: String) -> some View {
        MembershipCardView(
            member: Membership(
                name: "\(membershipType.rawValue.capitalized) Membership",
                validity: validity,
                details: "Access to benefits.",
                logo:"https://i.postimg.cc/jS0TCP35/SPEA-Without-Background.png"
            )
        )
        .padding(.bottom, 20)
    }

    private func benefitsTitle() -> some View {
        VStack(spacing: 10) {
            Divider().background(Color.gray)
            Text("Benefits")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .padding(.horizontal)
            Divider().background(Color.gray)
        }
        .padding(.vertical, 10)
    }

    private func memberLogoView(logoURL: String) -> some View {
        KFImage(URL(string: logoURL))
            .resizable()
            .placeholder { LoadingView() }
            .onSuccess { result in print("Image loaded successfully: \(result.cacheType)") }
            .onFailure { error in print("Failed to load image: \(error.localizedDescription)") }
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func memberDetailsSheet(member: Membership) -> some View {
        VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                // Membership Name
                Text(member.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.horizontal, .top])
                    .foregroundColor(.primary)
                
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal)
                
                // Membership Validity
                Text("Membership Validity")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text(member.validity)
                    .font(.body)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.primary)
                
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal)
                
                // Membership Details
                Text("Membership Details")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text(member.details)
                    .font(.body)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.primary)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .presentationDetents([.medium, .large], selection: $settingsDetent)
            .background(Color(UIColor.systemBackground))
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
        guard isMember, let expiryDate = membershipExpiryDate, membershipType != .lifetime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Membership Expiring Soon"
        content.body = "Your membership is expiring soon. Please renew to continue enjoying benefits."
        content.sound = UNNotificationSound.default

        if let warningDate = Calendar.current.date(byAdding: .day, value: -7, to: expiryDate), warningDate.timeIntervalSinceNow > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: warningDate.timeIntervalSinceNow, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling warning notification: \(error.localizedDescription)")
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
                    .frame(width: 70, height: 45)
                    .cornerRadius(5) // Apply rounded corners directly with cornerRadius

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text(member.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(member.validity)
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
            .padding(.bottom, 10)

            Divider()
                .background(Color.white)

            Text("Benefits")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)

            VStack(alignment: .leading, spacing: 5) {
                ForEach(memberBenefits(), id: \.self) { benefit in
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 18, weight: .semibold))

                        Text(benefit)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
            }
            .padding(.leading, 10)

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

    private func memberBenefits() -> [String] {
        return [
            "Access to exclusive events",
            "Special discounts",
            "Networking opportunities",
            "Free resources and tools"
        ]
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
