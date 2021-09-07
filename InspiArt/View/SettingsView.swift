import SwiftUI

struct SettingsView: View {
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Art Preferences")) {
                    DeleteAllArtsButton(showingDeleteAlert: $showingDeleteAlert)
                }
                Section(header: Text("About")) {
                    InfoSection(firstTextSection: "Version", secondTextSection: "0.9")
                    InfoSection(firstTextSection: "Author", secondTextSection: "Pawel Dera")
                }
                Section(header: Text("Privacy Policy")) {
                    HStack {
                        Link("Privacy Policy", destination: URL(string: "https://www.artic.edu/terms")!)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct InfoSection: View {
    let firstTextSection: String
    let secondTextSection: String
    
    var body: some View {
        HStack {
            Text(firstTextSection)
            Spacer()
            Text(secondTextSection)
                .foregroundColor(.gray)
                .opacity(0.8)
        }
    }
}

struct DeleteAllArtsButton: View {
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        Button("Delete All Favourite Arts") {
            showingDeleteAlert = true
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Warning!"),
                message: Text("Are you sure you want to delete all arts?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete")) {
                    PersistenceController.shared.deleteAllArts()
                }
            )
        }
    }
}
