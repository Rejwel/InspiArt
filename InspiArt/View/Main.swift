import SwiftUI

struct Main: View {
    @State private var showingTermsView: Bool
    
    init() {
        
        let acceptedTermsOfService = UserDefaults.standard.bool(forKey: "acceptedTermsOfService")
        _showingTermsView = !acceptedTermsOfService ? State(initialValue: true) : State(initialValue: false)
    }
    
    var body: some View {
        if showingTermsView {
            PrivacyPolicyView(showingThisView: $showingTermsView)
                .transition(.move(edge: .bottom))
        } else {
            ZStack {
                TabView {
                    YourArtView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Your Art")
                        }
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass.circle")
                            Text("Search")
                        }
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
            }
        }
    }
}
